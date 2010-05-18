class CreateGcertificates < ActiveRecord::Migration
  def self.up
    create_table :gcertificates do |t|
      t.boolean :valid
      t.integer :grade
      t.references :merchant
      t.timestamps
    end
  end

  def self.down
    drop_table :gcertificates
  end
end
