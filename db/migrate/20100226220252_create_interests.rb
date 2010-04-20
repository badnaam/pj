class CreateInterests < ActiveRecord::Migration
  def self.up
    create_table :interests do |t|
      t.String :interest_name
      t.references :interestible, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :interests
  end
end
