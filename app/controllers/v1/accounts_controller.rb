# frozen_string_literal: true
module V1
  # AccountsController
  class AccountsController < ApplicationController
    load_and_authorize_resource

    def show
      render json: @account
    end

    def update
      if resource_params[:email].present?
        fail Errors::InvalidEmailError if Account.pluck(:email).include?(resource_params[:email])

        AccountMailer.verification_new_email(@account.id, resource_params[:email]).deliver_later
      end

      if resource_params[:new_password].present?
        unless resource_params[:new_password] == resource_params[:new_password_confirmation]
          return render json: { errors: [{ description: '確認用パスワードが一致しません', status: 422 }] },
                        status: :unprocessable_entity
        end

        unless @account.authenticate(resource_params[:current_password])
          return render json: { errors: [{ description: '現在のパスワードが一致しません', status: 422 }] },
                        status: :unprocessable_entity
        end

        @account.update!(password: resource_params[:new_password])
      end

      render json: @account
    end

    def destroy
      @account.destroy!
      head 204
    end

    private

    def resource_params
      params.require(:account).permit(:email,
                                      :current_password,
                                      :new_password,
                                      :new_password_confirmation)
    end
  end
end
