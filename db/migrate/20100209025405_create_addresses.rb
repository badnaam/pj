class CreateAddresses < ActiveRecord::Migration
    def self.up
        create_table :addresses do |t|
            t.string :type
            t.string :street1, :null => false
            t.string :street2
            t.string :city, :null => false
            t.string :state, :null => false
            t.string :country, :default => "USA"
            t.integer :zip, :null => false
            t.decimal :lat
            t.decimal :long

            t.timestamps            

            t.references :addressible, :polymorphic => true
        end
    end

    def self.down
        drop_table :addresses
    end
end
