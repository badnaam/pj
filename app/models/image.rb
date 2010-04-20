class Image < ActiveRecord::Base
    belongs_to :imageible, :polymorphic => true
    
    has_attached_file :image, :styles => {:medium => "300x300>", :small => "100x100", :large => "500x400", :very_small => "50x50"},
      :path => ":rails_root/public/assets/images/:imageible_name/:id/:style.:extension",
      :url => "/assets/images/:imageible_name/:id/:style.:extension",
      :whiny_thumbnails => true
    validates_attachment_presence :image
    validates_attachment_size :image, :less_than => 1.megabytes
    validates_attachment_content_type :image, :content_type => ["image/jpeg", "image/png", "image/gif"]

#    def self.find_imageible(params)
#        params.each do |name, value|
#            if name =~ /(.+)_id$/
#                return $1.classify.constantize.find(value)
#            end
#        end
#    end
#
#    def self.find_imageible_name(params)
#        params.each do |name, value|
#            if name =~ /(.+)_id$/
#                return $1
#            end
#        end
#    end
end


