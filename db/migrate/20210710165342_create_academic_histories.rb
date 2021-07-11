class CreateAcademicHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :academic_histories, id: :uuid, comment: '学歴' do |t|
      t.string :name, null: false, comment: '学校名'
      t.string :faculty, comment: '学部名'
      t.date :since_date, null: false, comment: '入学日'
      t.date :until_date, comment: '卒業（予定）日'
      t.integer :classification, null: false, default: 0, comment: '分類'
      t.boolean :is_attended, null: false, default: false, comment: '在学中か'
      t.references :tutor, type: :uuid, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
