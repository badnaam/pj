class Merchant < ActiveRecord::Base
    Max_Images = 2
    
    BUSINESS_TYPE = ["Beauty/Spa", "Events & Entertainment", "Gym", "Healthcare/Wellness", "Restaurant", "Photo/Video Services", "Home Services",
        "Transportation"]
    belongs_to :user
    has_one :address, :as => :addressible
    has_many :images, :as => :imageible, :dependent => :destroy
    has_many :loyalty_benefits

    accepts_nested_attributes_for :address
    accepts_nested_attributes_for :images, :reject_if => proc {|attributes| attributes["image"].blank?}, :allow_destroy => true

    acts_as_mappable :through => :address
    #    after_save :update_merchant_users

    #    def update_merchant_users
    #
    #    end

    def imageible_name
        return "merchants"
    end

    def get_lat_lng
        return [self.address.lat, self.address.lng]
    end

    def self.get_lat_lng_events(events)
        events.collect{|e|e.get_lat_lng}
    end
end
