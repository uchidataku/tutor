# frozen_string_literal: true
module V1
  # ExaminationsController
  class ExaminationsController < ApplicationController
    before_action :initialize_examination, only: :create # FIXME: うまくload_and_authorize出来なかったので仕方なく

    load_and_authorize_resource :account, only: :index
    load_and_authorize_resource :student, through: :account, singleton: true, only: :index
    load_and_authorize_resource :examination, through: :student, shallow: true, only: :index
    load_and_authorize_resource expect: %i[index create]

    def index
      render json: @examinations
    end

    def show
      render json: @examination
    end

    def create
      authorize! :create, @examination
      @examination.save!
      render json: @examination, status: :created
    end

    def update
      @examination.update!(resource_params)
      render json: @examination
    end

    def destroy
      @examination.destroy!
      head 204
    end

    private

    def resource_params
      params.require(:examination).permit(:name,
                                          :classification,
                                          :school_year,
                                          :semester)
    end

    def initialize_examination
      student = Student.find_by(account_id: params[:account_id])
      fail Exceptions::InvalidParameterError if student.blank?

      @examination = Examination.new(resource_params.merge(student_id: student.id))
    end
  end
end
