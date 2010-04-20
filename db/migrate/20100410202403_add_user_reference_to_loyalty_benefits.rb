class AddUserReferenceToLoyaltyBenefits < ActiveRecord::Migration
  def self.up
      change_table :loyalty_benefits do |t|
          t.references :user
      end
  end

  def self.down
      t.remove_references :user
  end
end
