class Et < ActiveRecord::Base
    ETS_TYPE = [["Credit Points", "1"], [ "Debit Points", "2"]]
    belongs_to :merchant
    belongs_to :user

    validates_presence_of [:amount, :ets_type, :user_id, :merchant_id]
    validates_numericality_of :amount

    before_save :calculate_points
    after_save :update_level
    
    def calculate_points
        et_type = self.ets_type
        if et_type == 1 #Credit
            level = MerchantMembership.get_level(self.user_id, self.merchant_id)
            points = LoyaltyBenefit.get_points(self.amount, level, self.merchant_id)
            self.points = points
            return true
        elsif et_type == 2 #Debit
            avl_points = Et.user_id_equals(self.user_id).merchant_id_equals(self.merchant_id).sum(:points)
            if (avl_points - self.amount) < 0
                errors.add(:amount, I18n.t('et.not_enough'))
                return false
            else
                self.points = -1 * self.amount
            end
        else
            errors.add_to_base("Invalid transaction type")
            return false
        end
    end

    def update_level
        total_points = Et.user_id_equals(self.user_id).merchant_id_equals(self.merchant_id).sum(:points)
        new_level = 0
        unless total_points == 0
            LoyaltyBenefit.merchant_id_equals(self.merchant_id).each do |rec|
                if total_points > rec.points_req
                    new_level = rec.loyalty_level
                end
            end
        end
        membership = MerchantMembership.merchant_id_equals(self.merchant_id).user_id_equals(self.user_id).first
        membership.level = new_level
        membership.save
        if new_level >= 1
            #send email to user
        end
    end
end
