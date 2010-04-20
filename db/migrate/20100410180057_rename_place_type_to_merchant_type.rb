class RenamePlaceTypeToMerchantType < ActiveRecord::Migration
  def self.up
      rename_column :merchants, :place_type, :merchant_type
  end

  def self.down
      rename_column :merchants, :merchant_type, :place_type
  end
end
