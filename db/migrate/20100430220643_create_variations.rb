class CreateVariations < ActiveRecord::Migration
  def self.up
    create_table :variations do |t|
      t.int :variety_id
      t.int :plant_id
      t.references [:plant, :variety]
      t.timestamps
    end
  end

  def self.down
    drop_table :variations
  end
end
