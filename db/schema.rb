# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 37) do

  create_table "access_nodes", :force => true do |t|
    t.string   "name"
    t.integer  "sys_uptime"
    t.integer  "sys_load"
    t.integer  "sys_memfree"
    t.integer  "wifidog_uptime"
    t.datetime "last_seen"
    t.float    "long"
    t.float    "lat"
    t.float    "ele"
    t.string   "redirect_url"
    t.string   "mac"
    t.integer  "user_id"
    t.boolean  "track_mac"
    t.string   "auth_mode"
    t.string   "remote_addr"
    t.boolean  "couponcode_required", :default => false
    t.float    "lng"
    t.string   "address"
    t.integer  "time_limit"
    t.integer  "quota"
    t.integer  "authenticator_id"
  end

  create_table "authenticators", :force => true do |t|
    t.string   "auth_name",       :default => "DogOnRails Local"
    t.string   "auth_type",       :default => "local"
    t.string   "auth_server"
    t.string   "dictionary_path"
    t.string   "auth_secret"
    t.integer  "auth_timeout",    :default => 5
    t.integer  "access_node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banned_macs", :force => true do |t|
    t.string   "mac"
    t.datetime "banned_at"
  end

  create_table "batman_nodes", :force => true do |t|
    t.integer "access_node_id"
    t.string  "gateway_ip"
    t.boolean "gateway"
    t.string  "last_ip"
    t.string  "mac"
    t.string  "robin_ver"
    t.string  "batman_ver"
    t.string  "ssid"
    t.string  "pssid"
    t.integer "memfree"
    t.string  "uptime"
    t.integer "gw_qual"
    t.string  "routes"
    t.integer "hops"
    t.string  "nbs"
    t.string  "rank"
  end

  create_table "connections", :force => true do |t|
    t.string   "token"
    t.string   "remote_addr"
    t.integer  "gw_id",          :default => 0
    t.datetime "created_on"
    t.datetime "expires_on"
    t.datetime "updated_on"
    t.integer  "user_id"
    t.datetime "used_on"
    t.string   "ip"
    t.string   "mac"
    t.integer  "incoming_bytes", :default => 0
    t.integer  "outgoing_bytes", :default => 0
    t.integer  "access_node_id",                :null => false
  end

  create_table "globalconfs", :force => true do |t|
    t.string  "network_name"
    t.string  "logo_path"
    t.string  "center_lat"
    t.string  "center_lng"
    t.text    "ganal"
    t.string  "gmaps_key"
    t.integer "zoom"
  end

  create_table "node_settings", :force => true do |t|
    t.integer "access_node_id"
    t.string  "public_ssid",    :default => "FreeTheNet.ca"
    t.integer "download_limit", :default => 0
    t.integer "upload_limit",   :default => 0
    t.string  "private_ssid",   :default => "FreeTheNet.ca_Secure"
    t.string  "private_passwd", :default => "m3rhak1"
    t.string  "node_passwd",    :default => "m3rhak1"
  end

  create_table "notices", :force => true do |t|
    t.string   "title"
    t.integer  "scope"
    t.integer  "user_id"
    t.text     "notice_text"
    t.datetime "date_posted"
    t.integer  "access_node_id"
    t.datetime "expiry_date"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "system_settings", :force => true do |t|
    t.string "name",  :default => "", :null => false
    t.text   "value", :default => "", :null => false
  end

  add_index "system_settings", ["name"], :name => "index_system_settings_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "user_role"
    t.string   "activation_code"
    t.boolean  "activated",                               :default => false, :null => false
    t.boolean  "private",                                 :default => false
    t.string   "fbuid"
    t.datetime "fb_last_updated"
  end

end
