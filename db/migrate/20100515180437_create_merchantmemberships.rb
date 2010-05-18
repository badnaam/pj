class CreateMerchantmemberships < ActiveRecord::Migration
  def self.up
    create_table :merchantmemberships do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :merchantmemberships
  end
end
