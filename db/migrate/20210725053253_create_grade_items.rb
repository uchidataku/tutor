class CreateGradeItems < ActiveRecord::Migration[6.1]
  def change
    create_table :grade_items, id: :uuid, comment: '成績項目' do |t|
      t.string :name, null: false, comment: '科目名'
      t.integer :score, null: false, comment: '評価点'
      t.references :grade, type: :uuid, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
