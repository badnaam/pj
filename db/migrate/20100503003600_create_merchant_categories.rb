class CreateMerchantCategories < ActiveRecord::Migration
  def self.up
    create_table :merchant_categories do |t|
      t.string :category_name

      t.timestamps
    end
  end

  def self.down
    drop_table :merchant_categories
  end
end
