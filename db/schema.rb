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

ActiveRecord::Schema.define(version: 20170509123157) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "england_news", force: :cascade do |t|
    t.integer  "charity_id"
    t.integer  "regno"
    t.integer  "subno"
    t.string   "name"
    t.string   "orgtype"
    t.string   "gd"
    t.string   "aob"
    t.string   "nhs"
    t.string   "ha_no"
    t.string   "corr"
    t.string   "add1"
    t.string   "add2"
    t.string   "add3"
    t.string   "add4"
    t.string   "add5"
    t.string   "postcode"
    t.string   "phone"
    t.string   "fax"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "fystart"
    t.datetime "fyend"
    t.integer  "income"
    t.integer  "expend"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "laura_filters", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "northern_irelands", primary_key: "charity_id", force: :cascade do |t|
    t.string   "reg_charity_number"
    t.string   "sub_charity_number"
    t.string   "charity_name"
    t.string   "date_registered"
    t.string   "status"
    t.string   "date_for_financial_year_ending"
    t.string   "total_income"
    t.string   "total_spending"
    t.string   "charitable_spending"
    t.string   "income_generation_and_governance"
    t.string   "retained"
    t.string   "public_address"
    t.string   "website"
    t.string   "email"
    t.string   "telephone"
    t.string   "company_number"
    t.string   "what_the_charity_does"
    t.string   "who_the_charity_helps"
    t.string   "how_the_charity_works"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "punches", force: :cascade do |t|
    t.integer  "punchable_id",                          null: false
    t.string   "punchable_type", limit: 20,             null: false
    t.datetime "starts_at",                             null: false
    t.datetime "ends_at",                               null: false
    t.datetime "average_time",                          null: false
    t.integer  "hits",                      default: 1, null: false
    t.index ["average_time"], name: "index_punches_on_average_time"
    t.index ["punchable_type", "punchable_id"], name: "punchable_index"
  end

  create_table "scotlands", primary_key: "charity_id", force: :cascade do |t|
    t.string   "charity_number"
    t.string   "charity_name"
    t.string   "registered_date"
    t.string   "known_as"
    t.string   "charity_status"
    t.string   "postcode"
    t.string   "constitutional_form"
    t.string   "previous_constitutional_form_1"
    t.string   "geographical_spread"
    t.string   "main_operating_location"
    t.string   "purposes"
    t.string   "beneficiaries"
    t.string   "activities"
    t.string   "objectives"
    t.string   "principal_office_trustees_address"
    t.string   "website"
    t.integer  "most_recent_year_income"
    t.integer  "most_recent_year_expenditure"
    t.string   "mailing_cycle"
    t.string   "year_end"
    t.string   "parent_charity_name"
    t.string   "parent_charity_number"
    t.string   "parent_charity_country_of_registration"
    t.string   "designated_religious_body"
    t.string   "regulatory_type"
    t.decimal  "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.float    "latitude"
    t.float    "longitude"
    t.float    "lat"
    t.float    "lon"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
