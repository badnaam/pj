class CreateVoteTopics < ActiveRecord::Migration
  def self.up
    create_table :vote_topics do |t|
      t.string :topic
      t.date :start_date
      t.date :end_date

      t.references :merchant
      t.timestamps
    end
  end

  def self.down
    drop_table :vote_topics
  end
end
