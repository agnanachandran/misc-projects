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

ActiveRecord::Schema.define(version: 20140610192640) do

  create_table "current_ages", force: true do |t|
    t.integer  "age"
    t.integer  "portfolio_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "current_ages", ["portfolio_type_id"], name: "index_current_ages_on_portfolio_type_id"

  create_table "current_amounts", force: true do |t|
    t.integer  "amount"
    t.integer  "current_age_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "current_amounts", ["current_age_id"], name: "index_current_amounts_on_current_age_id"

  create_table "desired_yearly_incomes", force: true do |t|
    t.integer  "income"
    t.integer  "yearly_contribution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "desired_yearly_incomes", ["yearly_contribution_id"], name: "index_desired_yearly_incomes_on_yearly_contribution_id"

  create_table "portfolio_types", force: true do |t|
    t.string   "type_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "retirement_ages", force: true do |t|
    t.integer  "retirement_age"
    t.integer  "desired_yearly_income_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "retirement_ages", ["desired_yearly_income_id"], name: "index_retirement_ages_on_desired_yearly_income_id"

  create_table "yearly_contributions", force: true do |t|
    t.integer  "contribution"
    t.integer  "current_amount_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "yearly_contributions", ["current_amount_id"], name: "index_yearly_contributions_on_current_amount_id"

end
