class GeocodeCache < ActiveRecord::Base
    def self.store address, lat, lng
        GeocodeCache.find_or_create_by_address(:address=>address.downcase, :lat=>lat, :lng=>lng)
    end
end
