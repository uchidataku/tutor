class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students, id: :uuid, comment: '生徒' do |t|
      t.string :username, null: false, comment: 'ユーザー名'
      t.date :birthday, null: false, comment: '誕生日'
      t.text :introduction, comment: '自己紹介'
      t.string :junior_high_school_name, comment: '中学校名'
      t.string :high_school_name, comment: '高校名'
      t.string :technical_school_name, comment: '高専名'
      t.integer :current_classification, null: false, default: 0, comment: '現在の学位分類'
      t.integer :current_school_year, null: false, comment: '現在の学年'
      t.references :account, type: :uuid, foreign_key: { on_delete: :cascade }

      t.timestamps

      t.index :username, unique: true
    end
  end
end
