class Address < ActiveRecord::Base
    require 'ym4r/google_maps/geocoding'
    include Ym4r::GoogleMaps

    acts_as_mappable

    belongs_to :addressible, :polymorphic => true

    before_validation_on_create :geocode_address
    before_validation_on_update :geocode_address
    
    validates_length_of :zip, :is => 5
    validates_format_of :zip, :with => /^\d{5}(-\d{4})?$/, :message => "should be in the form 12345"
    validates_presence_of :street1, :city, :state, :zip

    def getaddress
        [street1, get_street2, city, state].compact.join(",")
    end

   
    def get_street2
        "#{street2}" unless street2.blank?
    end

    

    def self.get_lat_long_str(address)
        results = Geocoding::get(address)
        if results.status == Geocoding::GEO_SUCCESS
            ll = results[0].latlon
            return ll
        else
            return [0, 0]
        end
    end
    #    def self.get_lat_long_str(address)
    #        results = Geocoding::get(address)
    #        if results.status == Geocoding::GEO_SUCCESS
    #            ll = results[0].latlon
    #            return ll
    #        else
    #            return [0, 0]
    #        end
    #    end

    def self.get_lat_long(address)
        addr = address.getaddress
        logger.info "geocoding.." + address.to_s
        results = Geocoding::get(addr)
        if results.status == Geocoding::GEO_SUCCESS
            ll = results[0].latlon
            return ll
        end
    end

    private
    def geocode_address
        geo = Geokit::Geocoders::MultiGeocoder.geocode(getaddress)
        errors.add(:address, "Could not Geocode address") if !geo.success
        self.lat, self.lng = geo.lat,geo.lng if geo.success
    end
end
