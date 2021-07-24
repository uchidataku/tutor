class CreateExaminationItems < ActiveRecord::Migration[6.1]
  def change
    create_table :examination_items, id: :uuid, comment: '試験結果項目' do |t|
      t.string :name, null: false, comment: '科目名'
      t.integer :score, null: false, comment: '点数'
      t.float :average_score, comment: '平均点'
      t.references :examination, type: :uuid, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
