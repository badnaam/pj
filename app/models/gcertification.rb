class Gcertification < ActiveRecord::Base
    RESPONSE = {0 => "None", 1 => "Partial", 2 => "Completely"}
    belongs_to :gcertificate
    belongs_to :gcertstep
end
