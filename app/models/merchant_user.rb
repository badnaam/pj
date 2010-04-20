class MerchantUser < ActiveRecord::Base
  attr_accessible :user_id, :merchant_id
  belongs_to :user
  belongs_to :merchant
end
