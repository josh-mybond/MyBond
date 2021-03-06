# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_02_040838) do

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

  create_table "contacts", force: :cascade do |t|
    t.integer "status", default: 0
    t.string "email"
    t.string "mobile"
    t.string "message"
    t.json "history"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.integer "contract_type", default: 0
    t.integer "customer_id"
    t.integer "value", default: 0
    t.json "dates", default: []
    t.json "amounts", default: []
    t.json "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.string "agent_name"
    t.string "agent_telephone"
    t.string "agent_email"
    t.integer "property_weekly_rent"
    t.string "property_address"
    t.string "property_postcode"
    t.string "property_iso_country_code", default: "AU"
    t.string "rental_bond_board_id"
    t.integer "rental_bond", default: 0
    t.integer "vendor", default: 0
    t.string "split_authoriser_contact_id"
    t.string "pay_by_credit_card_guid"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "start_of_lease"
    t.datetime "end_of_lease"
    t.boolean "rolling_lease", default: false
    t.index ["end_date"], name: "index_contracts_on_end_date"
    t.index ["pay_by_credit_card_guid"], name: "index_contracts_on_pay_by_credit_card_guid"
    t.index ["property_postcode"], name: "index_contracts_on_property_postcode"
    t.index ["split_authoriser_contact_id"], name: "index_contracts_on_split_authoriser_contact_id"
    t.index ["start_date"], name: "index_contracts_on_start_date"
    t.index ["status"], name: "index_contracts_on_status"
    t.index ["vendor"], name: "index_contracts_on_vendor"
  end

  create_table "customers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "iso_country_code", default: "AU"
    t.string "mobile_number"
    t.datetime "date_of_birth"
    t.integer "residential_status", default: 0
    t.string "previous_address"
    t.string "previous_agent"
    t.index ["confirmation_token"], name: "index_customers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_customers_on_unlock_token", unique: true
  end

  create_table "postcodes", force: :cascade do |t|
    t.string "postcode", default: "", null: false
    t.float "risk", default: 0.0
    t.float "risk_limit", default: 0.8
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["postcode"], name: "index_postcodes_on_postcode"
  end

  create_table "privacy_policies", force: :cascade do |t|
    t.integer "status", default: 0
    t.string "summary"
    t.string "full"
    t.string "version"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "terms_and_conditions", force: :cascade do |t|
    t.integer "status", default: 0
    t.string "summary"
    t.string "full"
    t.string "version"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
