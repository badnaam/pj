class Merchant < ActiveRecord::Base
    Max_Images = 2
    
    BUSINESS_TYPE = {1 => "Beauty/Spa", 2 => "Events & Entertainment", 3 => "Gym", 4 => "Healthcare/Wellness", 5 => "Restaurant", 6 => "Photo/Video Services",
        7 => "Home Services", 8 => "Transportation", 9 => "Retails Store"}
#    BUSINESS_TYPE = ["Beauty/Spa", "Events & Entertainment", "Gym", "Healthcare/Wellness", "Restaurant", "Photo/Video Services", "Home Services",
#        "Transportation"]
    belongs_to :user
    has_one :address, :as => :addressible
    has_many :images, :as => :imageible, :dependent => :destroy
    has_many :loyalty_benefits

    accepts_nested_attributes_for :address
    accepts_nested_attributes_for :images, :reject_if => proc {|attributes| attributes["image"].blank?}, :allow_destroy => true

    acts_as_mappable :through => :address

    validates_presence_of [:name, :main_contact_name, :main_contact_number, :type]
    validates_associated :address
    
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
