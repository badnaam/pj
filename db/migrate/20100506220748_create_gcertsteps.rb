class CreateGcertsteps < ActiveRecord::Migration
  def self.up
    create_table :gcertsteps do |t|
      t.string :category_name
      t.string :step
      t.int :gpoint
      t.boolean :mandatory
      t.int :weight

      t.timestamps
    end
  end

  def self.down
    drop_table :gcertsteps
  end
end
