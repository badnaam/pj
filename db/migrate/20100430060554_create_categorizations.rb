class CreateCategorizations < ActiveRecord::Migration
  def self.up
    create_table :categorizations do |t|
      t.int :category_id
      t.int :event_id
      t.references :event, :category
      t.timestamps
    end
  end

  def self.down
    drop_table :categorizations
  end
end
