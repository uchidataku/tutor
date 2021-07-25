class CreateGrades < ActiveRecord::Migration[6.1]
  def change
    create_table :grades, id: :uuid, comment: '成績' do |t|
      t.integer :classification, null: false, default: 0, comment: '学位分類'
      t.integer :school_year, null: false, comment: '学年'
      t.integer :semester, null: false, default: 0, comment: '学期'
      t.references :student, type: :uuid, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
