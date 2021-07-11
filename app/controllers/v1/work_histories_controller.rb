# frozen_string_literal: true
module V1
  # WorkHistoriesController
  class WorkHistoriesController < ApplicationController
    before_action :initialize_work_history, only: :create # FIXME: うまくload_and_authorize出来なかったので仕方なく

    load_and_authorize_resource :account, only: :index
    load_and_authorize_resource :tutor, through: :account, singleton: true, only: :index
    load_and_authorize_resource :work_history, through: :tutor, shallow: true, only: :index
    load_and_authorize_resource expect: %i[index create]

    def index
      @work_histories = @work_histories.order(until_date: 'DESC')
      render json: @work_histories
    end

    def show
      render json: @work_history
    end

    def create
      authorize! :create, @work_history
      @work_history.save!
      render json: @work_history, status: :created
    end

    def update
      @work_history.update!(resource_params)
      render json: @work_history
    end

    def destroy
      @work_history.destroy!
      head 204
    end

    private

    def resource_params
      params.require(:work_history).permit(:name,
                                           :since_date,
                                           :until_date,
                                           :job_summary,
                                           :is_employed)
    end

    def initialize_work_history
      tutor = Tutor.find_by(account_id: params[:account_id])
      fail Exceptions::InvalidParameterError if tutor.blank?

      @work_history = WorkHistory.new(resource_params.merge(tutor_id: tutor.id))
    end
  end
end
