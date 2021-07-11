class CreateSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :subjects, id: :uuid, comment: '科目' do |t|
      t.string :name, null: false, comment: '科目名'
      t.integer :classification, null: false, default: 0, comment: '分類'

      t.timestamps

      t.index :name, unique: true
    end
  end
end
