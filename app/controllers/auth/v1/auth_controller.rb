# frozen_string_literal: true
module Auth
  module V1
    # AuthController
    class AuthController < ApplicationController
      skip_before_action :authenticate_account!

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

        render json: { account: ::AccountSerializer.new(account).as_json, token: account.jwt }, status: :created
      end

      private

      def resource_params
        params.require(:account).permit(:email, :password)
      end
    end
  end
end
