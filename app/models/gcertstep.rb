class Gcertstep < ActiveRecord::Base
    CATEGORIES = {"Energy" => ["Heating/Cooling/Ventilation", "Water Heating", "Misc", "Lighting", "Kithcen Equipment - Cooking",
            "Kitchen/Equipment - Refrigeration", "Office Equipment", "Renewable Energy"], "Water Efficieny" => ["Landscaping", "Kitchen", "Restrooms", "Other"],
        "Waste" => ["Recycling/Composting", "Construction Recycling", "Hazardous Waste", "Waste Reduction - Office Products", "Waste Reduction - Disposible Products",
            "Waste Reduction - Food"], "Recycled/Biobased disposibles" => ["No Disposibles", "Food Service Disposibles", "Other Recycled Paper Items", "Sanitary Paper", "Other Paper"],
        "Chemical/Pollution Reduction" => ["Transporation", "Site Selection", "StormWater Management", "Petroleum Reduction", "Chemical Reduction", "Pest Management", "Light Pollution",
            "Chemicals"], "Sustainable Food" => ["Organic Food/Beverage/Sustainable Seafood", "Meat & Dairy", "Meat-Free", "Local-100 miles", "Regional - 300 miles"],
        "Sustainable Furnishings/Building Materials" => []
    }
    has_many :gcertifications
    has_many :gcertificate, :through => :gcertifications

    has_many :certstep_merchant_categorizations, :dependent => :destroy
    has_many :merchant_categories, :through => :certstep_merchant_categorizations

    after_save :update_certstep_merchant_categorizations

    def update_certstep_merchant_categorizations
        unless self.certstep_merchant_categorizations.nil?
            self.certstep_merchant_categorizations.each do |a|
                a.destroy unless merchant_category_ids.include?(a.merchant_category_id.to_s)
                merchant_category_ids.delete(a.merchant_category_id.to_s)
            end
        end unless merchant_category_ids.nil?

        merchant_category_ids.each do |r|
            self.certstep_merchant_categorizations.create(:merchant_category_id => r) unless r.blank?
        end unless merchant_category_ids.nil?
    end
end
