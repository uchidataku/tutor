# frozen_string_literal: true
module Auth
  module V1
    # AuthController
    class AuthController < ApplicationController
      skip_before_action :authenticate_account!, except: :verify_new_email

      def sign_in
        account = Account.find_by(
          email: resource_params[:email]
        ).try(:authenticate, resource_params[:password])

        return head(401) if account.blank?

        account.update!(last_sign_in_at: Time.zone.now)
        render json: { account: ::AccountSerializer.new(account).as_json, token: account.jwt }
      end

      def sign_up
        fail Exceptions::InvalidEmailError if Account.pluck(:email).include?(resource_params[:email])

        account = Account.create!(resource_params)
        AccountMailer.verification_email(account.id)
        render json: { account: ::AccountSerializer.new(account).as_json, token: account.jwt }, status: :created
      end

      # アドレス確認（新規登録時）
      def verify_email
        account = Account.find_by(email_verification_token: params[:token])
        return head 403 if params[:token].blank? || account.blank?

        account.update!(email_verification_status: Account::EmailVerificationStatus::VERIFIED,
                        email_verification_token: nil)

        redirect_to URL::FrontEndUrls::EMAIL_CONFIRMED_URL
      end

      # アドレス確認（アドレス変更時）
      def verify_new_email
        account = Account.find_by(email_verification_token: params[:token])
        return head 403 if params[:token].blank? || account.blank?

        authorize! :manage, account
        account.update!(email: params[:email], email_verification_token: nil)

        redirect_to URL::FrontEndUrls::NEW_EMAIL_CONFIRMED_URL
      end

      private

      def resource_params
        params.require(:account).permit(:email, :password)
      end
    end
  end
end
