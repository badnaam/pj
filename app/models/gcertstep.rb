class Gcertstep < ActiveRecord::Base
    has_many :gcertifications
    has_many :merchants, :through => :gcertifications
end
