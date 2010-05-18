class CertstepMerchantCategorization < ActiveRecord::Base
    belongs_to :gcertstep
    belongs_to :merchant_category
end
