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

ActiveRecord::Schema.define(version: 2021_07_12_151031) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "academic_histories", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "学歴", force: :cascade do |t|
    t.string "name", null: false, comment: "学校名"
    t.string "faculty", comment: "学部名"
    t.date "since_date", null: false, comment: "入学日"
    t.date "until_date", comment: "卒業（予定）日"
    t.integer "classification", default: 0, null: false, comment: "分類"
    t.boolean "is_attended", default: false, null: false, comment: "在学中か"
    t.uuid "tutor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tutor_id"], name: "index_academic_histories_on_tutor_id"
  end

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "examination_items", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "試験結果項目", force: :cascade do |t|
    t.string "name", null: false, comment: "科目名"
    t.integer "score", null: false, comment: "点数"
    t.float "average_score", comment: "平均点"
    t.uuid "examination_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["examination_id"], name: "index_examination_items_on_examination_id"
  end

  create_table "examinations", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "試験（定期考査）", force: :cascade do |t|
    t.string "name", null: false, comment: "試験名"
    t.integer "classification", default: 0, null: false, comment: "学位分類"
    t.integer "school_year", null: false, comment: "学年"
    t.integer "semester", default: 0, null: false, comment: "学期"
    t.uuid "student_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["student_id"], name: "index_examinations_on_student_id"
  end

  create_table "jtis", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "JWTのホワイトリスト", force: :cascade do |t|
    t.uuid "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_jtis_on_account_id"
  end

  create_table "students", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "生徒", force: :cascade do |t|
    t.string "username", null: false, comment: "ユーザー名"
    t.date "birthday", null: false, comment: "誕生日"
    t.text "introduction", comment: "自己紹介"
    t.string "junior_high_school_name", comment: "中学校名"
    t.string "high_school_name", comment: "高校名"
    t.string "technical_school_name", comment: "高専名"
    t.integer "current_classification", default: 0, null: false, comment: "現在の学位分類"
    t.integer "current_school_year", null: false, comment: "現在の学年"
    t.uuid "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_students_on_account_id"
    t.index ["username"], name: "index_students_on_username", unique: true
  end

  create_table "subjects", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "科目", force: :cascade do |t|
    t.string "name", null: false, comment: "科目名"
    t.integer "classification", default: 0, null: false, comment: "分類"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_subjects_on_name", unique: true
  end

  create_table "tutors", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "チューター", force: :cascade do |t|
    t.string "first_name", null: false, comment: "名"
    t.string "last_name", null: false, comment: "姓"
    t.string "first_name_kana", null: false, comment: "名（カナ）"
    t.string "last_name_kana", null: false, comment: "姓（カナ）"
    t.string "username", null: false, comment: "ユーザーネーム"
    t.date "birthday", null: false, comment: "誕生日"
    t.text "introduction", comment: "自己紹介"
    t.string "phone", comment: "電話番号"
    t.string "address", comment: "住所"
    t.uuid "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_tutors_on_account_id"
    t.index ["username"], name: "index_tutors_on_username", unique: true
  end

  create_table "work_histories", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "職歴", force: :cascade do |t|
    t.string "name", null: false, comment: "企業名"
    t.date "since_date", null: false, comment: "入社日"
    t.date "until_date", comment: "退社日"
    t.text "job_summary", comment: "職務要約"
    t.boolean "is_employed", default: false, null: false, comment: "就業中か"
    t.uuid "tutor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tutor_id"], name: "index_work_histories_on_tutor_id"
  end

  add_foreign_key "academic_histories", "tutors", on_delete: :cascade
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "examination_items", "examinations", on_delete: :cascade
  add_foreign_key "examinations", "students", on_delete: :cascade
  add_foreign_key "jtis", "accounts", on_delete: :cascade
  add_foreign_key "students", "accounts", on_delete: :cascade
  add_foreign_key "tutors", "accounts", on_delete: :cascade
  add_foreign_key "work_histories", "tutors", on_delete: :cascade
end
