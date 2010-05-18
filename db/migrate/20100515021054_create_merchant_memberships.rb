class CreateMerchantMemberships < ActiveRecord::Migration
  def self.up
    create_table :merchant_memberships do |t|
      t.references :merchant, :user
      t.timestamps
    end
  end

  def self.down
    drop_table :merchant_memberships
  end
end
