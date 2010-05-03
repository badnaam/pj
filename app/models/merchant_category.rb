class MerchantCategory < ActiveRecord::Base
    has_many :merchant_categorizations
    has_many :merchants, :through => :merchant_categorizations

    def self.get_merchant_category_hash
        h = Hash.new
        self.all(:select => "id, category_name", :order => 'category_name').each do |rec|
            h[rec.id] = rec.category_name
        end
        return h
    end

end
