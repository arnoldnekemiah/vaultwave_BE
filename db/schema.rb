# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_10_133240) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "referrals", force: :cascade do |t|
    t.bigint "referrer_id", null: false
    t.bigint "referred_id", null: false
    t.datetime "clicked_at"
    t.datetime "converted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["referred_id"], name: "index_referrals_on_referred_id"
    t.index ["referrer_id"], name: "index_referrals_on_referrer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "wallet_address", null: false
    t.integer "waitlist_position"
    t.string "referral_code"
    t.integer "referred_by_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["referral_code"], name: "index_users_on_referral_code", unique: true
  end

  add_foreign_key "referrals", "users", column: "referred_id"
  add_foreign_key "referrals", "users", column: "referrer_id"
  add_foreign_key "users", "users", column: "referred_by_user_id"
end
