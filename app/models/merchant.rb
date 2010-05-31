class Merchant < ActiveRecord::Base
    Max_Images = 2
    
    belongs_to :owner, :class_name => "User"
    has_one :address, :as => :addressible, :dependent => :destroy
    has_many :images, :as => :imageible, :dependent => :destroy
    has_many :loyalty_benefits

    belongs_to :merchant_category
    has_many :gcertificates, :order => 'updated_at DESC'
    

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

    scope_procedure :created_between, lambda { |p| created_at_gte(p[0]).created_at_lt(p[1]) }
    scope_procedure :updated_between, lambda { |p| updated_at_gte(p[0]).updated_at_lt(p[1]) }

    #    after_save :update_merchant_categorizations

    #    named_scope :filled_gcertifications, :include => :gcertifications, :conditions => ['gcertifications.response in ?', (1..2) ]


    define_index do
        indexes :name, :sortable => true
        indexes loyalty_benefits.description, :as => :ben_desc
        indexes loyalty_benefits.red_desc, :as => :ben_red_desc
        indexes address.city, :as => :city
        
        has created_at, updated_at

        #        has addressible(:id), :as => :address_id
#        has addressible(:id), :as => :addessible_id
        has 'RADIANS(addresses.lat)', :as => :latitude,  :type => :float
        has 'RADIANS(addresses.lng)',:as => :longitude, :type => :float

        set_property :latitude_attr   => :latitude
        set_property :longitude_attr  => :longitude

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
