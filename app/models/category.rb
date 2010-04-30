class Category < ActiveRecord::Base
    has_many :categorizations
    has_many :events, :through => :categorizations
    default_scope :order => 'category_name'
#    has_many :merchants, :through => :categorizations

    def self.get_category_hash
        h = Hash.new
        self.all(:select => "id, category_name", :order => 'category_name').each do |rec|
            h[rec.id] = rec.category_name
        end
        return h
    end

    def self.get_categories
        a = Array.new
        recs = self.all(:select => "id, category_name", :order => 'category_name')
        recs.each do |rec|
            a << [rec.id, rec.category_name]
        end
        return a
    end
end
