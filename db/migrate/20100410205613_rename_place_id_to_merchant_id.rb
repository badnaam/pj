class RenamePlaceIdToMerchantId < ActiveRecord::Migration
  def self.up
      rename_column :merchant_users, :place_id, :merchant_id
  end

  def self.down
  end
end
