class CreateVoteItems < ActiveRecord::Migration
  def self.up
    create_table :vote_items do |t|
      t.string :desc

      t.timestamps
      t.references :vote_topic
    end
  end

  def self.down
    drop_table :vote_items
  end
end
