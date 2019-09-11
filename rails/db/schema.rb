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

ActiveRecord::Schema.define(version: 2019_09_11_110606) do

  create_table "certificates", force: :cascade do |t|
    t.string "fqdn"
    t.text "certificate"
    t.boolean "revoked", default: false
    t.datetime "revoked_at"
    t.datetime "valid_until"
    t.string "creator"
    t.string "revoked_user"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "organisation"
    t.integer "serial_number"
    t.string "version"
  end

end
