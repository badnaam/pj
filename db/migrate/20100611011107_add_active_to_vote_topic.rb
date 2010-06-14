class AddActiveToVoteTopic < ActiveRecord::Migration
  def self.up
    add_column :vote_topics, :active, :boolean
  end

  def self.down
    remove_column :vote_topics, :active
  end
end
