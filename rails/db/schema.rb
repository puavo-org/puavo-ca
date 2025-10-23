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

ActiveRecord::Schema[7.2].define(version: 2019_09_11_110606) do
  create_table "certificates", force: :cascade do |t|
    t.string "fqdn"
    t.text "certificate"
    t.boolean "revoked", default: false
    t.datetime "revoked_at", precision: nil
    t.datetime "valid_until", precision: nil
    t.string "creator"
    t.string "revoked_user"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "organisation"
    t.integer "serial_number"
    t.string "certchain_version"
  end
end
