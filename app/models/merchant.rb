class Merchant < ActiveRecord::Base
    Max_Images = 2
#    belongs_to :user

    has_many :images, :as => :imageible, :dependent => :destroy
    has_many :loyalty_benefits

    belongs_to :user
    
    accepts_nested_attributes_for :images, :reject_if => proc {|attributes| attributes["image"].blank?}, :allow_destroy => true

#    after_save :update_merchant_users

#    def update_merchant_users
#
#    end

    def imageible_name
        return "Merchants"
    end
end
