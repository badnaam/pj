class Merchant < ActiveRecord::Base
    Max_Images = 2
    
    belongs_to :owner, :class_name => "User"
    #    has_one :address, :as => :addressible, :dependent => :destroy
    has_many :images, :as => :imageible, :dependent => :destroy
    has_many :loyalty_benefits

    belongs_to :merchant_category
    has_many :gcertificates, :order => 'updated_at DESC'
    

    has_many :ets
    has_many :gcertifications
#    has_many :gcertsteps, :through => [:gcertifications]

    has_many :merchant_memberships, :dependent => :destroy
    has_many :users, :through => :merchant_memberships
    
    #    accepts_nested_attributes_for :address
    accepts_nested_attributes_for :images, :reject_if => proc {|attributes| attributes["image"].blank?}, :allow_destroy => true

    #    acts_as_mappable :through => :address
    acts_as_mappable :auto_geocode => {:field => :full_address, :error_message => "Invalid address"}

    validates_presence_of [:name, :main_contact_name, :main_contact_number, :type, :street1, :state, :country]
    #    validates_associated :address

    scope_procedure :created_between, lambda { |p| created_at_gte(p[0]).created_at_lt(p[1]) }
    scope_procedure :updated_between, lambda { |p| updated_at_gte(p[0]).updated_at_lt(p[1]) }

    before_validation_on_update :geocode_address#, :if => self.zip_changed?

    define_index do
        indexes :name, :sortable => true
        indexes loyalty_benefits.description, :as => :ben_desc
        indexes loyalty_benefits.red_desc, :as => :ben_red_desc
        indexes merchant_category.category_name, :as => :category, :facet => true
        indexes :description, :as => :description
        indexes :city, :as => :city, :facet => true
        indexes :state, :as => :state
        indexes :country, :as => :country
        indexes gcertifications.gcertstep.step

        has created_at, updated_at
#        has :city, :as => :merchant_city
        has gcertificates.total_score, :as => :eco_meter

        has 'RADIANS(lat)', :as => :lat,  :type => :float
        has 'RADIANS(lng)',:as => :lng, :type => :float

        set_property :latitude_attr  =>  "lat"
        set_property :longitude_attr => "lng"
    end

    def full_address
        street2 = nil if street2 == ""
        [street1, street2, city, state, zip].compact.join(",")
    end
    
   
    def imageible_name
        return "merchants"
    end

    def get_lat_lng
        #        return [self.address.lat, self.address.lng]
        return [self.lat, self.lng]
    end

    def self.get_lat_lng_events(merchants)
        merchants.collect{|e|e.get_lat_lng}
    end
    
    private

    def geocode_address
        geo = Geokit::Geocoders::MultiGeocoder.geocode(full_address)
        errors.add(:street1, "Could not Geocode address") if !geo.success
        if geo.success
            self.lat, self.lng = geo.lat,geo.lng
            self.zip = geo.zip if ((self.zip).blank? && geo.zip != nil)
        end
    end

end
