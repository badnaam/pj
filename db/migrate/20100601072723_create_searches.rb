class CreateSearches < ActiveRecord::Migration
    def self.up
        create_table :searches do |t|
            t.string :term
            t.string :group_by
            t.string :group_function
            t.string :group_clause
            t.string :sort_mode
            t.string :sort_by
            t.string :with
            t.string :origin
            t.string :facet

            t.references :user
            t.timestamps
        end
    end

    def self.down
        drop_table :searches
    end
end
