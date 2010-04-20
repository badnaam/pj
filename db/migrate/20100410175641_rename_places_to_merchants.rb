class RenamePlacesToMerchants < ActiveRecord::Migration
  def self.up
      rename_table :places, :merchants
  end

  def self.down
      rename_table :merchants, :places
  end
end
