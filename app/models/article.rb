class Article < ActiveRecord::Base
    belongs_to :user
    belongs_to :article_tag
    has_many :comments, :as =>:commentable

    acts_as_mappable :auto_geocode => {:field => :zip, :error_message => "Invalid Zip"}

    define_index do
        indexes user.username, :as => :author
        indexes subject, :as => :subject
        indexes content, :as => :content
#        indexes article_category.category_name, :as => :category, :facet => true
        indexes article_tag.tag_name, :as => :article_tag, :facet => true
#        indexes city, :as => :city, :facet => true
        indexes city, :as => :city, :facet => true

        
        has created_at, updated_at
        has article_tag_id, :as => :article_tag_id
        
        has user(:id), :as => :author

        has 'RADIANS(lat)', :as => :lat,  :type => :float
        has 'RADIANS(lng)',:as => :lng, :type => :float
        set_property :latitude_attr  =>  "lat"
        set_property :longitude_attr => "lng"
    end

    before_validation_on_update :geocode_address #, :if => self.zip_changed?
    
    private

    def geocode_address
        geo = Geokit::Geocoders::MultiGeocoder.geocode(zip)
        errors.add(:zip, "Could not Geocode Zip") if !geo.success
        if geo.success
            self.lat, self.lng, self.city = geo.lat,geo.lng, geo.city
        end
    end

end
