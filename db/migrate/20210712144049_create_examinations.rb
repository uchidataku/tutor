class CreateExaminations < ActiveRecord::Migration[6.1]
  def change
    create_table :examinations, id: :uuid, comment: '試験（定期考査）' do |t|
      t.string :name, null: false, comment: '試験名'
      t.integer :classification, null: false, default: 0, comment: '学位分類'
      t.integer :school_year, null: false, comment: '学年'
      t.integer :semester, null: false, default: 0, comment: '学期'
      t.references :student, type: :uuid, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
