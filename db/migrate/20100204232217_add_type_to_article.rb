class AddTypeToArticle < ActiveRecord::Migration
  def self.up
      add_column :articles, :type, :string, :null => false
  end

  def self.down
      remove_column(:articles, :type)
  end
end
