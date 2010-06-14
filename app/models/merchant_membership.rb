class MerchantMembership < ActiveRecord::Base
    belongs_to :user
    belongs_to :merchant

    def self.is_user_member?(merchant, user)
        if find_by_merchant_id_and_user_id(merchant.id, user.id).nil?
            return false
        end
        return true
    end

    def self.get_level(user_id, merchant_id)
        @membership = user_id_equals(user_id).merchant_id_equals(merchant_id).first
        level = @membership.level
    end
end

