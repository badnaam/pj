class Et < ActiveRecord::Base
    ETS_TYPE = [["Credit Points", "1"], [ "Debit Points", "2"]]
    belongs_to :merchant
    belongs_to :user

    validates_presence_of [:amount, :ets_type, :user_id, :merchant_id]
    validates_numericality_of :amount

    before_save :process_transaction

    def process_transaction
        et_type = self.ets_type
        if et_type == 1 #Credit
            level = MerchantMembership.get_level(self.user_id, self.merchant_id)
            points = LoyaltyBenefit.get_points(self.amount, level, self.merchant_id)
            unless credit(points, self.user_id, self.merchant_id)
                return false
            end
        elsif et_type == 2 #Debit
            unless debit(self.amount, self.user_id,self.merchant_id)
                return false
            end
        else
            errors.add_to_base("Invalid transaction type")
            return false
        end
        return true
    end

    def credit(points, uid, mid)
        rec = MerchantMembership.merchant_id_equals(mid).user_id_equals(uid).first
        unless rec.nil?
            tot_points = rec.total_points + points
            rec.update_attributes(:total_points => tot_points)
            if rec.save
                return true
            else
                errors.add_to_base("Failed to credit points, please try later.")
                return false
            end
        else
            errors.add_to_base("Invalid membership")
            return false
        end
    end

    def debit(points, uid, mid)
        rec = MerchantMembership.merchant_id_equals(mid).user_id_equals(uid).first
        unless rec.nil?
            tot_points = rec.total_points - points
            if tot_points < 0
                errors.add(:amount, "Not enough points for transaction")
                return false
            end
            rec.update_attributes(:total_points => tot_points)
            if rec.save
                return true
            else
                errors.add_to_base("Failed to debit points, please try later.")
                return false
                #                return false
            end
        else
            return false
        end
    end

end
