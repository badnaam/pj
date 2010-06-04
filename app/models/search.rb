class Search < ActiveRecord::Base
    belongs_to :user
    SEARCH_TYPE = {"all" => 1, "Merchant" => 2, "Event" => 3, "Article" => 4}
    METERS_PER_MILE = 1609.344
    
    def self.execute(keywords, var = {})
        @search_options = { :page => var[:page] || 1, :per_page => var[:per_page] }
        @geo = Address.geocode_rad(var[:geo])

        if @geo.nil?
            errors.add_to_base("Invalid Address")
        else
            @search_options.merge!(:geo => @geo, :with => {"@geodist" => (0.0..(var[:within].to_f * METERS_PER_MILE))}, :latitude_attr => :lat,
                :longitude_attr => :lng, :all_facets => true)
            if var[:refine]
                if var[:refine][:class]
                    result = var[:refine][:class].constantize.facets(keywords, @search_options)
                else
                    @search_options.merge!(:conditions => var[:refine])
                    result = ThinkingSphinx.facets(keywords, @search_options)
                end
            else 
                result = ThinkingSphinx.facets(keywords, @search_options)
            end
            return result
        end
    end
end
