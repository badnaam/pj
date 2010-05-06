class Gcertification < ActiveRecord::Base
    belongs_to :merchant
    belongs_to :gcertstep
end
