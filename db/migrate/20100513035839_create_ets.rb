class CreateEts < ActiveRecord::Migration
  def self.up
    create_table :ets do |t|
      t.integer :type
      t.string :comment
      t.integer :amount
      t.references :merchant, :user
      t.timestamps
    end
  end

  def self.down
    drop_table :ets
  end
end
