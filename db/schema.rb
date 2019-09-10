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

ActiveRecord::Schema.define(version: 2019_09_10_174601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "carriers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "internal", default: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "characteristics", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dealers", force: :cascade do |t|
    t.string "name"
    t.string "last_name"
    t.string "phone"
    t.string "address"
    t.decimal "comission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.boolean "admin", default: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "parent_id"
    t.boolean "courier", default: false
    t.boolean "grocer", default: false
    t.index ["email"], name: "index_dealers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_dealers_on_reset_password_token", unique: true
  end

  create_table "deliveries", force: :cascade do |t|
    t.string "recolection_id"
    t.string "sender_name"
    t.string "sender_address"
    t.string "sender_phone"
    t.string "receiver_name"
    t.string "receiver_address"
    t.string "receiver_phone"
    t.string "receiver_contact"
    t.string "receiver_nit"
    t.string "populated_receiver_id"
    t.string "populated_origin_id"
    t.string "service_type"
    t.decimal "secured_amount"
    t.text "observations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "cod"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "municipalities", force: :cascade do |t|
    t.string "cod"
    t.string "name"
    t.string "department_id"
    t.string "header_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parameters", force: :cascade do |t|
    t.string "tag"
    t.string "description"
    t.integer "int_value"
    t.string "text_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag"], name: "index_parameters_on_tag"
  end

  create_table "pieces", force: :cascade do |t|
    t.decimal "weight"
    t.decimal "amount_cod"
    t.bigint "delivery_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number_p"
    t.string "type_p"
    t.index ["delivery_id"], name: "index_pieces_on_delivery_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "description"
    t.string "sku"
    t.bigint "category_id"
    t.boolean "active"
    t.decimal "quantity"
    t.decimal "price"
    t.decimal "cost"
    t.bigint "characteristic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "balance"
    t.decimal "min"
    t.decimal "max"
    t.decimal "weight", default: "0.0"
    t.decimal "old_price"
    t.decimal "old_cost"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["characteristic_id"], name: "index_products_on_characteristic_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "next"
    t.string "tag"
  end

  create_table "transaction_details", force: :cascade do |t|
    t.bigint "transaction_id"
    t.bigint "product_id"
    t.decimal "unit_price"
    t.decimal "quantity"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_transaction_details_on_product_id"
    t.index ["transaction_id"], name: "index_transaction_details_on_transaction_id"
  end

  create_table "transaction_logs", force: :cascade do |t|
    t.string "tag"
    t.string "description"
    t.string "started_at"
    t.string "ended_at"
    t.text "messages"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "request_json"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "description"
    t.string "client"
    t.string "address"
    t.string "address2"
    t.string "phone"
    t.decimal "amount"
    t.bigint "status_id"
    t.bigint "dealer_id"
    t.integer "type_id"
    t.string "tracking_number"
    t.bigint "carrier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "courier_id"
    t.bigint "delivery_id"
    t.text "url_reference"
    t.text "url_recolection"
    t.index ["carrier_id"], name: "index_transactions_on_carrier_id"
    t.index ["dealer_id"], name: "index_transactions_on_dealer_id"
    t.index ["delivery_id"], name: "index_transactions_on_delivery_id"
    t.index ["status_id"], name: "index_transactions_on_status_id"
    t.index ["type_id"], name: "index_transactions_on_type_id"
  end

  create_table "villages", force: :cascade do |t|
    t.string "cod"
    t.string "name"
    t.string "department_id"
    t.string "municipality_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "pieces", "deliveries"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "characteristics"
  add_foreign_key "transaction_details", "products"
  add_foreign_key "transaction_details", "transactions"
  add_foreign_key "transactions", "carriers"
  add_foreign_key "transactions", "dealers"
  add_foreign_key "transactions", "deliveries"
  add_foreign_key "transactions", "statuses"
end
