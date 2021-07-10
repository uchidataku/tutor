# frozen_string_literal: true
module V1
  # AcademicHistoriesController
  class AcademicHistoriesController < ApplicationController
    load_and_authorize_resource :account
    load_and_authorize_resource :tutor, through: :account, shallow: true
    load_and_authorize_resource :academic_history, through: :tutor, shallow: true

    def index
      @academic_histories = @academic_histories.order(until_date: 'DESC')
      render json: @academic_histories
    end

    def show
      render json: @academic_history
    end

    def create
      @academic_history.save!
      render json: @academic_histories, status: :created
    end

    def update
      @academic_history.update!(resource_params)
      render json: @academic_histories
    end

    def destroy
      @academic_history.destroy!
      head 204
    end

    private

    def resource_params
      params.require(:academic_history).permit(:name,
                                               :faculty,
                                               :since_date,
                                               :until_date,
                                               :classification,
                                               :is_attended)
    end
  end
end
