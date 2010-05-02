class Variety < ActiveRecord::Base
    has_many :variations
    has_many :plants, :through => :variations
end
