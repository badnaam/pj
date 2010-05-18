class CreateCertstepMerchantCategorizations < ActiveRecord::Migration
  def self.up
    create_table :certstep_merchant_categorizations do |t|

      t.timestamps
      t.references :merchant_category, :gcertstep
    end
  end

  def self.down
    drop_table :certstep_merchant_categorizations
  end
end
