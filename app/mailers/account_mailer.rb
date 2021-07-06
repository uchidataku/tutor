# frozen_string_literal: true
# AccountMailer
class AccountMailer < ApplicationMailer
  def verification_email(account_id)
    @account = Account.find(account_id)
    @account.update!(email_verification_token: SecureRandom.uuid)

    mail(to: @account.email, subject: '[ProbWorks] メールアドレス確認のお願い')
  end

  def verification_new_email(account_id, email)
    @account = Account.find(account_id)
    @email = email
    @account.update!(email_verification_token: SecureRandom.uuid)

    mail(to: @email, subject: '[ProbWorks] 新しいメールアドレス確認のお願い')
  end
end
