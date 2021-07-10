# frozen_string_literal: true
module V1
  # TutorsController
  class TutorsController < ApplicationController
    load_and_authorize_resource :account
    load_and_authorize_resource :tutor, through: :account, singleton: true

    def show
      render json: @tutor
    end

    def create
      unless current_account.email_verification_status == Account::EmailVerificationStatus::VERIFIED
        fail Exceptions::EmailVerificationError
      end

      @tutor.save!
      render json: @tutor, status: :created
    end

    def update
      @tutor.update!(resource_params)

      render json: @tutor
    end

    private

    def resource_params
      params.require(:tutor).permit(:first_name,
                                    :last_name,
                                    :first_name_kana,
                                    :last_name_kana,
                                    :username,
                                    :birthday,
                                    :introduction,
                                    :phone,
                                    :address,
                                    :avatar)
    end
  end
end
