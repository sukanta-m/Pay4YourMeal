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

ActiveRecord::Schema.define(version: 20160828101705) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "marketings", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.datetime "marketing_on"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.decimal  "amount"
    t.integer  "added_by"
    t.integer  "group_id"
    t.boolean  "is_approved",  default: false
  end

  add_index "marketings", ["group_id"], name: "index_marketings_on_group_id", using: :btree

  create_table "meals", force: :cascade do |t|
    t.integer  "member_id"
    t.boolean  "is_taken"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "meal_type"
  end

  add_index "meals", ["member_id"], name: "index_meals_on_member_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "invited_by"
    t.integer  "group_id"
    t.datetime "respond_on"
    t.boolean  "is_accepted"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "token"
  end

  add_index "members", ["group_id"], name: "index_members_on_group_id", using: :btree
  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean  "remember_me"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.decimal  "amount"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "marketings", "groups"
  add_foreign_key "meals", "members"
  add_foreign_key "members", "groups"
  add_foreign_key "members", "users"
end
