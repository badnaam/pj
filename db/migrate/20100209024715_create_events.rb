class CreateEvents < ActiveRecord::Migration
    def self.up
        create_table :events do |t|
            t.string :title, :null => false
            t.text :description, :null => false
            t.datetime :event_date, :null =>false
            t.string :main_contact_name
            t.string :main_contact_number
            t.text :details

            t.references :user
            t.timestamps
        end
    end

    def self.down
        drop_table :events
    end
end
