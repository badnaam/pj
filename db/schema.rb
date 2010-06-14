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

ActiveRecord::Schema.define(:version => 20100614193619) do

  create_table "addresses", :force => true do |t|
    t.string   "street1",                                          :null => false
    t.string   "street2"
    t.string   "city",                                             :null => false
    t.string   "state",                                            :null => false
    t.string   "country",                       :default => "USA"
    t.string   "zip",              :limit => 5,                    :null => false
    t.float    "lat",                                              :null => false
    t.float    "lng",                                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "addressible_id"
    t.string   "addressible_type"
  end

  add_index "addresses", ["addressible_id", "addressible_type"], :name => "index_addresses_on_addressible_id_and_addressible_type"
  add_index "addresses", ["lat"], :name => "lat"
  add_index "addresses", ["lat"], :name => "lat_2"
  add_index "addresses", ["lng"], :name => "lng"
  add_index "addresses", ["lng"], :name => "lng_2"

  create_table "applicabilities", :force => true do |t|
    t.integer  "merchant_id"
    t.integer  "gcertstep_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_tags", :force => true do |t|
    t.string   "tag_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.string   "subject"
    t.integer  "article_tag_id",                :null => false
    t.text     "content"
    t.string   "zip",            :limit => 8
    t.string   "city",           :limit => 100
    t.float    "lat"
    t.float    "lng"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["article_tag_id"], :name => "index_articles_on_article_tag_id"
  add_index "articles", ["user_id"], :name => "index_articles_on_user_id"

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["role_id"], :name => "index_assignments_on_role_id"
  add_index "assignments", ["user_id"], :name => "index_assignments_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categorizations", :force => true do |t|
    t.integer  "event_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categorizations", ["category_id"], :name => "index_categorizations_on_category_id"
  add_index "categorizations", ["event_id"], :name => "index_categorizations_on_event_id"

  create_table "certstep_merchant_categorizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_category_id"
    t.integer  "gcertstep_id"
  end

  add_index "certstep_merchant_categorizations", ["gcertstep_id"], :name => "index_certstep_merchant_categorizations_on_gcertstep_id"
  add_index "certstep_merchant_categorizations", ["merchant_category_id"], :name => "index_certstep_merchant_categorizations_on_merchant_category_id"

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id",          :null => false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "ets", :force => true do |t|
    t.integer  "ets_type",    :limit => 2, :null => false
    t.string   "comment"
    t.integer  "amount"
    t.integer  "points",                   :null => false
    t.integer  "merchant_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ets", ["merchant_id"], :name => "index_ets_on_merchant_id"
  add_index "ets", ["user_id"], :name => "index_ets_on_user_id"

  create_table "events", :force => true do |t|
    t.string   "title",               :null => false
    t.text     "description",         :null => false
    t.date     "event_date",          :null => false
    t.string   "main_contact_name"
    t.string   "main_contact_number"
    t.text     "details"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "gcertificates", :force => true do |t|
    t.boolean  "cert_valid"
    t.integer  "grade"
    t.integer  "total_score", :null => false
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gcertificates", ["merchant_id"], :name => "index_gcertificates_on_merchant_id"

  create_table "gcertifications", :force => true do |t|
    t.integer  "score",           :limit => 1, :null => false
    t.integer  "response",        :limit => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
    t.integer  "gcertstep_id"
    t.integer  "gcertificate_id",              :null => false
  end

  add_index "gcertifications", ["gcertificate_id"], :name => "index_gcertifications_on_gcertificate_id"
  add_index "gcertifications", ["gcertstep_id"], :name => "index_gcertifications_on_gcertstep_id"

  create_table "gcertsteps", :force => true do |t|
    t.string   "category_name"
    t.string   "sub_category",  :limit => 200, :null => false
    t.string   "step"
    t.integer  "weight",        :limit => 1,   :null => false
    t.integer  "gpoint",        :limit => 1,   :null => false
    t.boolean  "mandatory"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geocode_caches", :force => true do |t|
    t.string   "address"
    t.float    "lat"
    t.float    "lng"
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

  add_index "images", ["imageible_id", "imageible_type"], :name => "index_images_on_imageible_id_and_imageible_type"

  create_table "interests", :force => true do |t|
    t.integer  "interestible_id"
    t.string   "interestible_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "interest_name"
  end

  add_index "interests", ["interestible_id", "interestible_type"], :name => "index_interests_on_interestible_id_and_interestible_type"

  create_table "loyalty_benefits", :force => true do |t|
    t.integer  "loyalty_level"
    t.integer  "points_req",                                   :null => false
    t.string   "description"
    t.string   "red_desc",                      :limit => 500, :null => false
    t.integer  "point_bonus"
    t.integer  "point_bonus_multiplier"
    t.string   "perk_bonus"
    t.boolean  "active"
    t.boolean  "community_use",                                :null => false
    t.date     "point_bonus_window_start"
    t.datetime "point_bonus_window_time_start",                :null => false
    t.date     "point_bonus_window_end"
    t.datetime "point_bonus_window_time_end",                  :null => false
    t.integer  "point_conversion_ratio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
  end

  add_index "loyalty_benefits", ["merchant_id"], :name => "index_loyalty_benefits_on_merchant_id"

  create_table "merchant_categories", :force => true do |t|
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchant_categorizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
    t.integer  "merchant_category_id"
  end

  create_table "merchant_memberships", :force => true do |t|
    t.integer  "level",        :limit => 1, :default => 1
    t.integer  "total_points",              :default => 0
    t.integer  "merchant_id",                              :null => false
    t.integer  "user_id",                                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "merchant_memberships", ["merchant_id"], :name => "index_merchant_memberships_on_merchant_id"
  add_index "merchant_memberships", ["user_id"], :name => "index_merchant_memberships_on_user_id"

  create_table "merchant_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchantmemberships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchants", :force => true do |t|
    t.string   "name"
    t.string   "main_contact_name",          :limit => 100,                                                  :null => false
    t.string   "main_contact_number",        :limit => 15,                                                   :null => false
    t.decimal  "rating_average",                            :precision => 6, :scale => 2, :default => 0.0,   :null => false
    t.decimal  "rating_average_eco",                        :precision => 6, :scale => 2, :default => 0.0
    t.decimal  "rating_average_rewards",                    :precision => 6, :scale => 2, :default => 0.0
    t.decimal  "rating_average_quality",                    :precision => 6, :scale => 2, :default => 0.0
    t.boolean  "active",                                                                  :default => false, :null => false
    t.integer  "green_grade",                :limit => 1,                                 :default => 0,     :null => false
    t.integer  "merchant_memberships_count",                                              :default => 0,     :null => false
    t.string   "description",                :limit => 500,                                                  :null => false
    t.string   "website",                    :limit => 150,                                                  :null => false
    t.string   "phone",                      :limit => 15,                                                   :null => false
    t.string   "street1",                    :limit => 50,                                                   :null => false
    t.string   "street2",                    :limit => 20
    t.string   "city",                       :limit => 15,                                                   :null => false
    t.string   "state",                      :limit => 5,                                                    :null => false
    t.string   "zip",                        :limit => 8,                                                    :null => false
    t.string   "country",                    :limit => 10,                                :default => "USA", :null => false
    t.float    "lat"
    t.float    "lng"
    t.string   "fax",                        :limit => 15
    t.integer  "merchant_category_id",                                                                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  add_index "merchants", ["merchant_category_id"], :name => "index_merchants_on_merchant_category_id"
  add_index "merchants", ["name"], :name => "name"
  add_index "merchants", ["owner_id"], :name => "index_merchants_on_owner_id"

  create_table "offers", :force => true do |t|
    t.string   "header",             :null => false
    t.string   "description"
    t.integer  "points_needed",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "offerable_id"
    t.string   "offerable_type"
    t.boolean  "notify_members"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "offers", ["header", "description", "offerable_id", "offerable_type"], :name => "header"

  create_table "rates", :force => true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars",         :null => false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], :name => "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], :name => "index_rates_on_rater_id"

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

  create_table "searches", :force => true do |t|
    t.string   "keywords"
    t.string   "classes"
    t.integer  "per_page",   :limit => 2,                :null => false
    t.integer  "page",       :limit => 2,                :null => false
    t.string   "conditions"
    t.string   "order"
    t.string   "within"
    t.string   "geo"
    t.integer  "user_id"
    t.integer  "stype",      :limit => 1, :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["user_id"], :name => "user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "username",                                            :null => false
    t.integer  "role_id"
    t.string   "email",                            :default => "",    :null => false
    t.string   "crypted_password"
    t.boolean  "active",                           :default => false, :null => false
    t.integer  "ut",                 :limit => 1,  :default => 1,     :null => false
    t.string   "first_name",         :limit => 10
    t.string   "last_name",          :limit => 10
    t.string   "phone",              :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.string   "perishable_token",                 :default => "",    :null => false
  end

  add_index "users", ["email"], :name => "email", :unique => true
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["role_id"], :name => "index_users_on_role_id"

  create_table "vote_items", :force => true do |t|
    t.string   "option",        :null => false
    t.string   "info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vote_topic_id"
  end

  add_index "vote_items", ["option", "vote_topic_id"], :name => "desc"

  create_table "vote_topics", :force => true do |t|
    t.string   "topic",                      :null => false
    t.integer  "points"
    t.string   "header",      :limit => 250, :null => false
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  add_index "vote_topics", ["merchant_id"], :name => "merchant_id"
  add_index "vote_topics", ["topic"], :name => "topic"

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "fk_voteables"
  add_index "votes", ["voter_id", "voter_type"], :name => "fk_voters"

end
