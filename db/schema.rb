# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150418210158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "balance_cents",    default: 0,     null: false
    t.string   "balance_currency", default: "USD", null: false
    t.string   "user_dn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  add_index "accounts", ["code", "user_dn"], name: "index_accounts_on_code_and_user_dn", unique: true, using: :btree

  create_table "checkins", force: true do |t|
    t.integer  "meeting_id"
    t.string   "user_dn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkins", ["user_dn", "meeting_id"], name: "index_checkins_on_user_dn_and_meeting_id", unique: true, using: :btree

  create_table "meetings", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "location"
    t.datetime "start"
    t.datetime "finish"
    t.boolean  "required",    default: false
    t.boolean  "verified",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "user_dn"
    t.string   "icon",       default: "newspaper-o"
    t.boolean  "public",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "polls", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.text     "options"
    t.text     "permissions"
    t.boolean  "closed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.string   "poster_dn"
    t.string   "description"
    t.string   "icon"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sponsor_dn"
  end

  create_table "votes", force: true do |t|
    t.integer  "poll_id"
    t.string   "user_dn"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
