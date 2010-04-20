class RenameMerchantOwnershipToMerchantUser < ActiveRecord::Migration
  def self.up
      rename_table :place_ownerships, :merchant_users
  end

  def self.down
      rename_table :merchant_users, :merchant_ownerships
  end
end
