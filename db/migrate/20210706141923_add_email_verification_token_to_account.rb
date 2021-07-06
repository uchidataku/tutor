class AddEmailVerificationTokenToAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :email_verification_token, :uuid, comment: 'メール確認用トークン'
  end
end
