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

ActiveRecord::Schema.define(version: 20171127069718) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stocks", force: :cascade do |t|
    t.string "name"
    t.string "bse_code"
    t.string "symbol"
    t.decimal "last_buying_price", precision: 19, scale: 4, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "users_stock_id"
    t.integer "quantity", default: 0
    t.decimal "price_per_unit", default: "0.0"
    t.date "transacted_at"
    t.integer "transaction_type", default: 0
    t.decimal "brokerage", default: "0.0"
    t.boolean "is_brokerage_percentage"
    t.boolean "is_brokerage_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["users_stock_id"], name: "index_transactions_on_users_stock_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_stocks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "stock_id"
    t.integer "quantity", default: 0
    t.decimal "last_buying_price", precision: 19, scale: 4, default: "0.0"
    t.decimal "average_buying_price", precision: 19, scale: 4, default: "0.0"
    t.decimal "investment", precision: 19, scale: 4, default: "0.0"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_users_stocks_on_stock_id"
    t.index ["user_id"], name: "index_users_stocks_on_user_id"
  end

  add_foreign_key "transactions", "users_stocks"
  add_foreign_key "users_stocks", "stocks"
  add_foreign_key "users_stocks", "users"
end
