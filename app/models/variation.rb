class Variation < ActiveRecord::Base
    belongs_to :plant
    belongs_to :variety
end
