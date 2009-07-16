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

ActiveRecord::Schema.define(:version => 20090126212539) do

  create_table "enquiries", :force => true do |t|
    t.datetime "created_at"
    t.boolean  "newsletter",                 :default => false
    t.string   "source"
    t.string   "name"
    t.string   "role"
    t.string   "company"
    t.string   "email"
    t.string   "telephone"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "county"
    t.string   "postcode"
    t.string   "prefered_method_of_contact"
    t.text     "message"
    t.string   "gender"
    t.integer  "age"
    t.string   "referal"
  end

  create_table "file_uploads", :force => true do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.string   "title"
    t.datetime "created_at"
  end

  create_table "images", :force => true do |t|
    t.datetime "created_at"
    t.string   "alt"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.float    "resize",             :default => 1.0
    t.integer  "crop_w"
    t.integer  "crop_h"
    t.integer  "crop_x"
    t.integer  "crop_y"
  end

  create_table "pages", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "title"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.string   "nav_title"
    t.string   "slug"
    t.string   "slug_path"
    t.string   "title_path"
    t.boolean  "locked",           :default => false, :null => false
    t.boolean  "published",        :default => false, :null => false
    t.datetime "publish_date"
    t.string   "url"
    t.text     "intro"
    t.text     "body"
  end

  create_table "users", :force => true do |t|
    t.boolean  "admin",                                    :default => false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "crypted_password",          :limit => 128, :default => "",    :null => false
    t.string   "salt",                      :limit => 128, :default => "",    :null => false
    t.string   "remember_token"
    t.string   "remember_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",                              :default => 0,     :null => false
    t.integer  "failed_login_count",                       :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
  end

end
