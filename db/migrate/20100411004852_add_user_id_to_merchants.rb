class AddUserIdToMerchants < ActiveRecord::Migration
  def self.up
      add_column :merchants, :user_id, :integer
  end

  def self.down
      remove_column :merchants, :user_id, :integer
  end
end
