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

ActiveRecord::Schema.define(version: 20150106160339) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "managers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "managers", ["email"], name: "index_managers_on_email", unique: true, using: :btree
  add_index "managers", ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true, using: :btree

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tr_activity_id"
    t.string   "tr_activity_type", limit: 255
    t.string   "minplus",          limit: 255
    t.decimal  "tr_amount"
  end

  create_table "programs", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "punch_card"
    t.integer  "free_punch_new"
    t.integer  "free_punch_profile"
    t.integer  "cardnumber_generator"
    t.integer  "voucher_days",                     default: 30
    t.string   "card_prefix",          limit: 255
  end

  create_table "punches", force: :cascade do |t|
    t.string   "punch_code", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "cash_value"
    t.integer  "program_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    limit: 255, default: "",  null: false
    t.string   "cardnumber",               limit: 255
    t.decimal  "balance",                              default: 0.0, null: false
    t.datetime "updated_balance_datetime"
    t.boolean  "is_active",                default: false
    t.string   "gender",                   limit: 1
    t.date     "date_of_birth"
    t.string   "device_id",                limit: 255
    t.string   "api_key",                  limit: 255
    t.integer  "program_id"
    t.decimal  "balance_total"
  end

  create_table "vouchers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "cash_date"
    t.decimal  "cash_value"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pod_id",     limit: 255
    t.datetime "valid_date"
    t.boolean  "is_active",              default: true
    t.string   "title",      limit: 255, default: "Volle spaarkaart"
    t.string   "subtitle",   limit: 255, default: "GRATIS kopje koffie bij volle spaarkaart"
    t.string   "image_url",  limit: 255
  end

  # execute "SELECT setval('vouchers_id_seq', 100000)"

end
