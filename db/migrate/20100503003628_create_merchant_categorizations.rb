class CreateMerchantCategorizations < ActiveRecord::Migration
  def self.up
    create_table :merchant_categorizations do |t|

      t.timestamps
      t.references :merchant, :merchant_category
    end
  end

  def self.down
    drop_table :merchant_categorizations
  end
end
