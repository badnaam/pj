class Offer < ActiveRecord::Base
    belongs_to :offerable, :polymorphic => true
    has_many :images, :as => :imageible, :dependent => :destroy

#    acts_as_mappable :through => :merchant

    has_attached_file :image, :styles => {:small => "100x100", :large => "400x300", :very_small => "50x50"},
      :path => ":rails_root/public/assets/images/offers/:id/:style.:extension",
      :url => "/assets/images/offers/:id/:style.:extension",
      :whiny_thumbnails => true
    validates_presence_of :header, :points_needed
    validates_numericality_of :points_needed, :only_integer => true, :greater_than => 0
    validates_length_of :description, :maximum => 250
    validates_attachment_size :image, :less_than => 1.megabytes
    validates_attachment_content_type :image, :content_type => ["image/jpeg", "image/png", "image/gif"]

    acts_as_mappable
    
    before_save :copy_merchant_lat_lng

    def copy_merchant_lat_lng
        if self.offerable_type == "Merchant"
            m = Merchant.find(self.offerable_id)
            self.lat = m.lat
            self.lng = m.lng
        end
    end
    
    def imageible_name
        return "offers"
    end
end
