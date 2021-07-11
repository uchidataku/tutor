class CreateWorkHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :work_histories, id: :uuid, comment: '職歴' do |t|
      t.string :name, null: false, comment: '企業名'
      t.date :since_date, null: false, comment: '入社日'
      t.date :until_date, comment: '退社日'
      t.text :job_summary, comment: '職務要約'
      t.boolean :is_employed, null: false, default: false, comment: '就業中か'
      t.references :tutor, type: :uuid, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
