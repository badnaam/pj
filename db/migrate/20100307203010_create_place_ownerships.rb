class CreatePlaceOwnerships < ActiveRecord::Migration
  def self.up
    create_table :place_ownerships do |t|
      t.integer :user_id
      t.integer :place_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :place_ownerships
  end
end
