class MerchantCategorization < ActiveRecord::Base
    belongs_to :merchant
    belongs_to :merchant_category
end
