class CreateArticleCategories < ActiveRecord::Migration
  def self.up
    create_table :article_categories do |t|
      t.string :category_name

      t.timestamps
    end
  end

  def self.down
    drop_table :article_categories
  end
end
