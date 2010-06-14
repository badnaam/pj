class AddNotifyMembersToOffer < ActiveRecord::Migration
  def self.up
    add_column :offers, :notify_members, :boolean
  end

  def self.down
    remove_column :offers, :notify_members
  end
end
