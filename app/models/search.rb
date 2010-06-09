class Search < ActiveRecord::Base
    belongs_to :user
    serialize :conditions
    serialize :classes
    SEARCH_TYPE = {"all" => 1, "Merchant" => 2, "Event" => 3, "Article" => 4}
    METERS_PER_MILE = 1609.344
    DEFAULT_LOCATION = "94131"
    DEFAULT_WITHIN = "10"
    DEFAULT_PER_PAGE = "5"
    
    def self.execute(var)
        if var[:geo].nil?
            return nil
        else
            #            @geo = Address.geocode_rad(var[:geo])
            @geo = [0.658336879619334, -2.13225004421321]
        end
        
        if @geo.nil?
            errors.add_to_base("Invalid Address")
        else
            var.merge!(:geo => @geo, :with => {"@geodist" => (0.0..(var[:within].to_f * METERS_PER_MILE))}, :latitude_attr => :lat,
                :longitude_attr => :lng, :all_facets => true, :class_facet => true)
            keywords = var[:keywords]
            var.delete("keywords")
            result = ThinkingSphinx.facets(keywords, var)
        end
        return result
    end
    
    def self.process_params (p, filter_search)
        var = Hash.new
        var [:keywords] = p[:search][:keywords]
        var[:order] = p[:search][:order] || "@relevance DESC"
        var[:geo] =  p[:search][:geo] || Search::DEFAULT_LOCATION
        var[:within] =  p[:search][:within] || Search::DEFAULT_WITHIN
        var[:per_page] = p[:search][:per_page] || Search::DEFAULT_PER_PAGE
        var[:page] = p[:page] || 1
        #ignore filters if not filter search
        if filter_search
            unless p[:search][:conditions].nil?
                h = Hash.new
                p[:search][:conditions].keys.each do |k|
                    unless p[:search][:conditions][k].nil?
                        h[k] = p[:search][:conditions][k].values.join(" | ").gsub("/", " ")
                    end
                end
                var[:conditions] = h
            end
            unless p[:search][:classes].nil? || p[:search][:classes][:class].nil?
                arr = Array.new
                p[:search][:classes][:class].values.each do |x|
                    arr << x.constantize
                end
                var[:classes] = arr
            end
        end
        return var
    end
end
