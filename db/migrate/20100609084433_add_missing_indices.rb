class AddMissingIndices < ActiveRecord::Migration
  def self.up

    # These indexes were found by searching for AR::Base finds on your application
    # It is strongly recommanded that you will consult a professional DBA about your infrastucture and implemntation before
    # changing your database in that matter.
    # There is a possibility that some of the indexes offered below is not required and can be removed and not added, if you require
    # further assistance with your rails application, database infrastructure or any other problem, visit:
    #
    # http://www.railsmentors.org
    # http://www.railstutor.org
    # http://guides.rubyonrails.org


    add_index :interests, [:interestible_id, :interestible_type]
    add_index :loyalty_benefits, :merchant_id
    add_index :addresses, [:addressible_id, :addressible_type]
    add_index :merchants, :merchant_category_id
    add_index :merchants, :owner_id
    add_index :certstep_merchant_categorizations, :merchant_category_id
    add_index :certstep_merchant_categorizations, :gcertstep_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :user_id
    add_index :friendships, :user_id
    add_index :friendships, :friend_id
    add_index :ets, :merchant_id
    add_index :ets, :user_id
    add_index :gcertifications, :gcertstep_id
    add_index :gcertifications, :gcertificate_id
    add_index :events, :user_id
    add_index :merchant_memberships, :merchant_id
    add_index :merchant_memberships, :user_id
    add_index :images, [:imageible_id, :imageible_type]
    add_index :gcertificates, :merchant_id
    add_index :users, :role_id
    add_index :assignments, :role_id
    add_index :assignments, :user_id
    add_index :articles, :user_id
    add_index :articles, :article_tag_id
    add_index :categorizations, :event_id
    add_index :categorizations, :category_id
  end

  def self.down
    remove_index :interests, :column => [:interestible_id, :interestible_type]
    remove_index :loyalty_benefits, :merchant_id
    remove_index :addresses, :column => [:addressible_id, :addressible_type]
    remove_index :merchants, :merchant_category_id
    remove_index :merchants, :owner_id
    remove_index :certstep_merchant_categorizations, :merchant_category_id
    remove_index :certstep_merchant_categorizations, :gcertstep_id
    remove_index :comments, :column => [:commentable_id, :commentable_type]
    remove_index :comments, :user_id
    remove_index :friendships, :user_id
    remove_index :friendships, :friend_id
    remove_index :ets, :merchant_id
    remove_index :ets, :user_id
    remove_index :gcertifications, :gcertstep_id
    remove_index :gcertifications, :gcertificate_id
    remove_index :events, :user_id
    remove_index :merchant_memberships, :merchant_id
    remove_index :merchant_memberships, :user_id
    remove_index :images, :column => [:imageible_id, :imageible_type]
    remove_index :gcertificates, :merchant_id
    remove_index :users, :role_id
    remove_index :assignments, :role_id
    remove_index :assignments, :user_id
    remove_index :articles, :user_id
    remove_index :articles, :article_tag_id
    remove_index :categorizations, :event_id
    remove_index :categorizations, :category_id
  end
end
