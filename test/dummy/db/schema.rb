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

ActiveRecord::Schema.define(version: 20130917153931) do

  create_table "majigs", force: true do |t|
    t.string   "foo"
    t.integer  "thing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "things", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.text     "description"
    t.string   "radio_options"
    t.boolean  "checkbox_option"
    t.string   "file_name"
    t.string   "telephone_number"
    t.string   "url"
    t.integer  "count"
    t.date     "my_date"
    t.time     "my_time"
    t.datetime "my_datetime"
    t.string   "choice"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
