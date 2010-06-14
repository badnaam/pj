class CreateGeocodeCaches < ActiveRecord::Migration
  def self.up
    create_table :geocode_caches do |t|
      t.string :address
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end

  def self.down
    drop_table :geocode_caches
  end
end
