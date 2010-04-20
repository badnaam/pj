class CreateLoyaltyBenefits < ActiveRecord::Migration
  def self.up
    create_table :loyalty_benefits do |t|
      t.integer :level
      t.string :description
      t.integer :type
      t.integer :point_bonus
      t.integer :point_bonus_multiplier
      t.string :perk_bonus
      t.boolean :active
      t.datetime :point_bonus_window_start
      t.datetime :point_bonus_window_end
      t.datetime :perk_bonus_window_start
      t.datetime :perk_bonus_window_end
      t.integer :point_conversion_ratio

      t.timestamps

       t.references :merchant
    end
  end

  def self.down
    drop_table :loyalty_benefits
  end
end
