class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :accounts, id: :uuid, comment: 'アカウント' do |t|
      t.string :email, null: false, comment: 'メールアドレス'
      t.string :username, null: false, comment: 'ユーザー名'
      t.string :password_digest, null: false, comment: '暗号化されたパスワード'
      t.integer :email_verification_status, null: false, default: 0, comment: 'メールアドレスの確認状態'
      t.date :birthday, null: true, comment: '誕生日'
      t.datetime :last_sign_in_at, null: false, default: -> { 'NOW()' }, comment: 'サインイン日時'
      t.datetime :last_notification_read_at, null: false, default: -> { 'NOW()' }, comment: '既読日時'

      t.timestamps

      t.index :email, unique: true
      t.index :username, unique: true
    end
  end
end
