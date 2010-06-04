class Address < ActiveRecord::Base
    require 'ym4r/google_maps/geocoding'
    include Ym4r::GoogleMaps

    STATES = [['Select a State', 'None'],
        ['Alabama', 'AL'],
        ['Alaska', 'AK'],
        ['Arizona', 'AZ'],
        ['Arkansas', 'AR'],
        ['California', 'CA'],
        ['Colorado', 'CO'],
        ['Connecticut', 'CT'],
        ['Delaware', 'DE'],
        ['District Of Columbia', 'DC'],
        ['Florida', 'FL'],
        ['Georgia', 'GA'],
        ['Hawaii', 'HI'],
        ['Idaho', 'ID'],
        ['Illinois', 'IL'],
        ['Indiana', 'IN'],
        ['Iowa', 'IA'],
        ['Kansas', 'KS'],
        ['Kentucky', 'KY'],
        ['Louisiana', 'LA'],
        ['Maine', 'ME'],
        ['Maryland', 'MD'],
        ['Massachusetts', 'MA'],
        ['Michigan', 'MI'],
        ['Minnesota', 'MN'],
        ['Mississippi', 'MS'],
        ['Missouri', 'MO'],
        ['Montana', 'MT'],
        ['Nebraska', 'NE'],
        ['Nevada', 'NV'],
        ['New Hampshire', 'NH'],
        ['New Jersey', 'NJ'],
        ['New Mexico', 'NM'],
        ['New York', 'NY'],
        ['North Carolina', 'NC'],
        ['North Dakota', 'ND'],
        ['Ohio', 'OH'],
        ['Oklahoma', 'OK'],
        ['Oregon', 'OR'],
        ['Pennsylvania', 'PA'],
        ['Rhode Island', 'RI'],
        ['South Carolina', 'SC'],
        ['South Dakota', 'SD'],
        ['Tennessee', 'TN'],
        ['Texas', 'TX'],
        ['Utah', 'UT'],
        ['Vermont', 'VT'],
        ['Virginia', 'VA'],
        ['Washington', 'WA'],
        ['West Virginia', 'WV'],
        ['Wisconsin', 'WI'],
        ['Wyoming', 'WY']]

    acts_as_mappable :auto_geocode => true

    belongs_to :addressible, :polymorphic => true

    #    before_validation_on_create :geocode_address
    #    before_validation_on_update :geocode_address
    
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

    def self.get_lat_long(address)
        addr = address.getaddress
        logger.info "geocoding.." + address.to_s
        results = Geocoding::get(addr)
        if results.status == Geocoding::GEO_SUCCESS
            ll = results[0].latlon
            return ll
        end
    end
    
    def self.get_radian(lat, lng)
        return [(lat / 180.0) * Math::PI, (lng / 180.0) * Math::PI]
    end

    def self.geocode_rad(str)
        geo = Geokit::Geocoders::MultiGeocoder.geocode(str)
        if geo.success
            return get_radian(geo.lat, geo.lng)
        else
            return nil
        end
    end

    private
    def geocode_address
        geo = Geokit::Geocoders::MultiGeocoder.geocode(full_address)
        errors.add(:address, "Could not Geocode address") if !geo.success
        self.lat, self.lng = geo.lat,geo.lng if geo.success
    end
end
