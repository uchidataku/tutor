class CreateTutors < ActiveRecord::Migration[6.1]
  def change
    create_table :tutors, id: :uuid, comment: 'チューター' do |t|
      t.string :first_name, null: false, comment: '名'
      t.string :last_name, null: false, comment: '姓'
      t.string :first_name_kana, null: false, comment: '名（カナ）'
      t.string :last_name_kana, null: false, comment: '姓（カナ）'
      t.string :username, null: false, comment: 'ユーザーネーム'
      t.date :birthday, null: false, comment: '誕生日'
      t.text :introduction, comment: '自己紹介'
      t.string :phone, comment: '電話番号'
      t.string :address, comment: '住所'
      t.references :account, type: :uuid, foreign_key: { on_delete: :cascade }

      t.timestamps

      t.index :username, unique: true
    end
  end
end
