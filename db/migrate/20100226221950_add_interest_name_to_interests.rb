class AddInterestNameToInterests < ActiveRecord::Migration
  def self.up
    add_column :interests, :interest_name, :string
  end

  def self.down
    remove_column :interests, :interest_name
  end
end
