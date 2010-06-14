class CreateOffers < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.string :header
      t.string :description
      t.date :start_date
      t.date :end_date
      t.integer :points_needed

      t.timestamps
      t.belongs_to :offerable, :polymorphic => true
    end
  end

  def self.down
    drop_table :offers
  end
end
