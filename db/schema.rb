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

ActiveRecord::Schema.define(version: 2021_07_06_141923) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "アカウント", force: :cascade do |t|
    t.string "email", null: false, comment: "メールアドレス"
    t.string "password_digest", null: false, comment: "暗号化されたパスワード"
    t.integer "email_verification_status", default: 0, null: false, comment: "メールアドレスの確認状態"
    t.datetime "last_sign_in_at", default: -> { "now()" }, null: false, comment: "サインイン日時"
    t.datetime "last_notification_read_at", default: -> { "now()" }, null: false, comment: "既読日時"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "email_verification_token", comment: "メール確認用トークン"
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

  create_table "jtis", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "JWTのホワイトリスト", force: :cascade do |t|
    t.uuid "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_jtis_on_account_id"
  end

  add_foreign_key "jtis", "accounts", on_delete: :cascade
end
