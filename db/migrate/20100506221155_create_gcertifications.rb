class CreateGcertifications < ActiveRecord::Migration
  def self.up
    create_table :gcertifications do |t|
      t.integer :score
      t.boolean :expired

      t.timestamps
      t.references :merchant, :gcertstep, :gcertificate
    end
  end

  def self.down
    drop_table :gcertifications
  end
end
