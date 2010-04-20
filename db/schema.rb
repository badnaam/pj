# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100411004852) do

  create_table "addresses", :force => true do |t|
    t.string   "street1",                                                                           :null => false
    t.string   "street2"
    t.string   "city",                                                                              :null => false
    t.string   "state",                                                                             :null => false
    t.string   "country",                                                        :default => "USA"
    t.string   "zip",              :limit => 5,                                                     :null => false
    t.float    "lat",              :limit => 18
    t.decimal  "lng",                            :precision => 18, :scale => 12
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "addressible_id"
    t.string   "addressible_type"
  end

  add_index "addresses", ["lat"], :name => "lat"
  add_index "addresses", ["lng"], :name => "lng"

  create_table "articles", :force => true do |t|
    t.string   "subject"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "article_type", :null => false
  end

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id",          :null => false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title",               :null => false
    t.text     "description",         :null => false
    t.datetime "event_date",          :null => false
    t.string   "main_contact_name"
    t.string   "main_contact_number"
    t.text     "details"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "imageible_id"
    t.string   "imageible_type"
    t.string   "image_file_name"
    t.string   "image_description"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "interests", :force => true do |t|
    t.integer  "interestible_id"
    t.string   "interestible_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "interest_name"
  end

  create_table "loyalty_benefits", :force => true do |t|
    t.integer  "level"
    t.string   "description"
    t.integer  "type"
    t.integer  "point_bonus"
    t.integer  "point_bonus_multiplier"
    t.string   "perk_bonus"
    t.boolean  "active"
    t.datetime "point_bonus_window_start"
    t.datetime "point_bonus_window_end"
    t.datetime "perk_bonus_window_start"
    t.datetime "perk_bonus_window_end"
    t.integer  "point_conversion_ratio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
    t.integer  "user_id"
  end

  create_table "merchant_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchants", :force => true do |t|
    t.string   "name"
    t.string   "merchant_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",       :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.boolean  "active",             :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.string   "perishable_token",   :default => "",    :null => false
  end

  add_index "users", ["email"], :name => "email", :unique => true
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
