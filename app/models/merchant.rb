class Merchant < ActiveRecord::Base
    Max_Images = 2
    
    belongs_to :owner, :class_name => "User"
    has_one :address, :as => :addressible, :dependent => :destroy
    has_many :images, :as => :imageible, :dependent => :destroy
    has_many :loyalty_benefits

    belongs_to :merchant_category
    has_many :gcertificates
    
    #    has_many :merchant_categorizations, :dependent => :destroy
    #    has_many :merchant_categories, :through => :merchant_categorizations

    has_many :ets
    has_many :gcertifications
    has_many :gcertsteps, :through => [:gcertifications]

    has_many :merchant_memberships, :dependent => :destroy
    has_many :users, :through => :merchant_memberships
    
    accepts_nested_attributes_for :address
    accepts_nested_attributes_for :images, :reject_if => proc {|attributes| attributes["image"].blank?}, :allow_destroy => true

    acts_as_mappable :through => :address

    validates_presence_of [:name, :main_contact_name, :main_contact_number, :type]
    validates_associated :address

    after_save :update_merchant_categorizations

    
    def update_merchant_categorizations
        unless self.merchant_categorizations.nil?
            self.merchant_categorizations.each do |a|
                a.destroy unless merchant_category_ids.include?(a.merchant_category_id.to_s)
                merchant_category_ids.delete(a.merchant_category_id.to_s)
            end
        end unless merchant_category_ids.nil?

        merchant_category_ids.each do |r|
            self.merchant_categorizations.create(:merchant_category_id => r) unless r.blank?
        end unless merchant_category_ids.nil?
    end

    def imageible_name
        return "merchants"
    end

    def get_lat_lng
        return [self.address.lat, self.address.lng]
    end

    def self.get_lat_lng_events(merchants)
        merchants.collect{|e|e.get_lat_lng}
    end
end
