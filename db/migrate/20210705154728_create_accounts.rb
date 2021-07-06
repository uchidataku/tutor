class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :accounts, id: :uuid, comment: 'アカウント' do |t|
      t.string :email, null: false, comment: 'メールアドレス'
      t.string :password_digest, null: false, comment: '暗号化されたパスワード'
      t.integer :email_verification_status, null: false, default: 0, comment: 'メールアドレスの確認状態'
      t.datetime :last_sign_in_at, null: false, default: -> { 'NOW()' }, comment: 'サインイン日時'
      t.datetime :last_notification_read_at, null: false, default: -> { 'NOW()' }, comment: '既読日時'

      t.timestamps

      t.index :email, unique: true
    end
  end
end
