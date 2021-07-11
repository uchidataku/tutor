# frozen_string_literal: true
module V1
  # AcademicHistoriesController
  class AcademicHistoriesController < ApplicationController
    before_action :initialize_academic_history, only: :create # FIXME: うまくload_and_authorize出来なかったので仕方なく

    load_and_authorize_resource :account, only: :index
    load_and_authorize_resource :tutor, through: :account, singleton: true, only: :index
    load_and_authorize_resource :academic_history, through: :tutor, shallow: true, only: :index
    load_and_authorize_resource expect: %i[index create]

    def index
      @academic_histories = @academic_histories.order(until_date: 'DESC')
      render json: @academic_histories
    end

    def show
      render json: @academic_history
    end

    def create
      authorize! :create, @academic_history
      @academic_history.save!
      render json: @academic_history, status: :created
    end

    def update
      @academic_history.update!(resource_params)
      render json: @academic_history
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

    def initialize_academic_history
      tutor = Tutor.find_by(account_id: params[:account_id])
      fail Exceptions::InvalidParameterError unless tutor.present?

      @academic_history = AcademicHistory.new(resource_params.merge(tutor_id: tutor.id))
    end
  end
end
