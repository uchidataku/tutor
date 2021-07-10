# frozen_string_literal: true
module V1
  # StudentsController
  class StudentsController < ApplicationController
    load_and_authorize_resource :account
    load_and_authorize_resource :student, through: :account, singleton: true

    def show
      render json: @student
    end

    def create
      unless current_account.email_verification_status == Account::EmailVerificationStatus::VERIFIED
        fail Exceptions::EmailVerificationError
      end

      @student.save!
      render json: @student, status: :created
    end

    def update
      @student.update!(resource_params)

      render json: @student
    end

    private

    def resource_params
      params.require(:student).permit(:username,
                                      :birthday,
                                      :introduction,
                                      :junior_high_school_name,
                                      :high_school_name,
                                      :technical_school_name,
                                      :current_classification,
                                      :current_school_year,
                                      :avatar)
    end
  end
end
