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

ActiveRecord::Schema.define(:version => 20101017195016) do

  create_table "action_types", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "template"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actions", :force => true do |t|
    t.integer  "community_id"
    t.integer  "action_type_id"
    t.integer  "user_id"
    t.string   "actionable_type"
    t.integer  "actionable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "actions", ["action_type_id"], :name => "actions_action_type_id_fk"
  add_index "actions", ["community_id"], :name => "actions_community_id_fk"
  add_index "actions", ["user_id"], :name => "actions_user_id_fk"

  create_table "communities", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "subdomain"
    t.integer  "privacy",     :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "communities", ["user_id"], :name => "communities_user_id_fk"

  create_table "discussions", :force => true do |t|
    t.integer  "community_id"
    t.integer  "user_id"
    t.boolean  "sticky",        :default => false, :null => false
    t.string   "title"
    t.string   "slug"
    t.integer  "replies_count", :default => 0,     :null => false
    t.datetime "last_reply_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discussions", ["community_id"], :name => "discussions_community_id_fk"
  add_index "discussions", ["user_id"], :name => "discussions_user_id_fk"

  create_table "memberships", :force => true do |t|
    t.integer  "community_id"
    t.integer  "user_id"
    t.integer  "access",                          :null => false
    t.boolean  "approved",     :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["community_id"], :name => "memberships_community_id_fk"
  add_index "memberships", ["user_id"], :name => "memberships_user_id_fk"

  create_table "page_revisions", :force => true do |t|
    t.integer  "page_id"
    t.integer  "user_id"
    t.text     "body",         :null => false
    t.text     "body_as_html", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_revisions", ["page_id"], :name => "page_revisions_page_id_fk"
  add_index "page_revisions", ["user_id"], :name => "page_revisions_user_id_fk"

  create_table "pages", :force => true do |t|
    t.integer  "community_id"
    t.integer  "user_id"
    t.integer  "position"
    t.string   "name"
    t.string   "slug"
    t.boolean  "user_created", :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["community_id"], :name => "pages_community_id_fk"
  add_index "pages", ["user_id"], :name => "pages_user_id_fk"

  create_table "parameters", :force => true do |t|
    t.integer  "resource_id"
    t.integer  "user_id"
    t.integer  "position"
    t.string   "name"
    t.text     "description"
    t.boolean  "required",    :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parameters", ["resource_id"], :name => "parameters_resource_id_fk"
  add_index "parameters", ["user_id"], :name => "parameters_user_id_fk"

  create_table "replies", :force => true do |t|
    t.integer  "discussion_id"
    t.integer  "user_id"
    t.text     "body",          :null => false
    t.text     "body_as_html",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "replies", ["discussion_id"], :name => "replies_discussion_id_fk"
  add_index "replies", ["user_id"], :name => "replies_user_id_fk"

  create_table "resources", :force => true do |t|
    t.integer  "community_id"
    t.integer  "user_id"
    t.integer  "position"
    t.string   "path"
    t.string   "url"
    t.string   "slug"
    t.text     "description"
    t.string   "supported_formats"
    t.string   "supported_methods"
    t.boolean  "requires_authentication", :default => false, :null => false
    t.boolean  "rate_limited",            :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resources", ["community_id"], :name => "resources_community_id_fk"
  add_index "resources", ["user_id"], :name => "resources_user_id_fk"

  create_table "responses", :force => true do |t|
    t.integer  "resource_id"
    t.integer  "user_id"
    t.integer  "position"
    t.string   "format"
    t.string   "http_code"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["resource_id"], :name => "responses_resource_id_fk"
  add_index "responses", ["user_id"], :name => "responses_user_id_fk"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email_address",                     :null => false
    t.string   "crypted_password",                  :null => false
    t.string   "password_salt",                     :null => false
    t.string   "persistence_token",                 :null => false
    t.string   "perishable_token",                  :null => false
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "actions", "action_types", :name => "actions_action_type_id_fk"
  add_foreign_key "actions", "communities", :name => "actions_community_id_fk"
  add_foreign_key "actions", "users", :name => "actions_user_id_fk"

  add_foreign_key "communities", "users", :name => "communities_user_id_fk"

  add_foreign_key "discussions", "communities", :name => "discussions_community_id_fk"
  add_foreign_key "discussions", "users", :name => "discussions_user_id_fk"

  add_foreign_key "memberships", "communities", :name => "memberships_community_id_fk"
  add_foreign_key "memberships", "users", :name => "memberships_user_id_fk"

  add_foreign_key "page_revisions", "pages", :name => "page_revisions_page_id_fk"
  add_foreign_key "page_revisions", "users", :name => "page_revisions_user_id_fk"

  add_foreign_key "pages", "communities", :name => "pages_community_id_fk"
  add_foreign_key "pages", "users", :name => "pages_user_id_fk"

  add_foreign_key "parameters", "resources", :name => "parameters_resource_id_fk"
  add_foreign_key "parameters", "users", :name => "parameters_user_id_fk"

  add_foreign_key "replies", "discussions", :name => "replies_discussion_id_fk"
  add_foreign_key "replies", "users", :name => "replies_user_id_fk"

  add_foreign_key "resources", "communities", :name => "resources_community_id_fk"
  add_foreign_key "resources", "users", :name => "resources_user_id_fk"

  add_foreign_key "responses", "resources", :name => "responses_resource_id_fk"
  add_foreign_key "responses", "users", :name => "responses_user_id_fk"

end
