# frozen_string_literal: true
module V1
  # GradesController
  class GradesController < ApplicationController
    before_action :initialize_grade, only: :create # FIXME: うまくload_and_authorize出来なかったので仕方なく

    load_and_authorize_resource :account, only: :index
    load_and_authorize_resource :student, through: :account, singleton: true, only: :index
    load_and_authorize_resource :grade, through: :student, shallow: true, only: :index
    load_and_authorize_resource expect: %i[index create]

    def index
      render json: @grades
    end

    def show
      render json: @grade
    end

    def create
      authorize! :create, @grade
      @grade.save!
      render json: @grade, status: :created
    end

    def update
      @grade.update!(resource_params)
      render json: @grade
    end

    def destroy
      @grade.destroy!
      head 204
    end

    private

    def resource_params
      params.require(:grade).permit(:classification, :school_year, :semester)
    end

    def initialize_grade
      student = Student.find_by(account_id: params[:account_id])
      fail Exceptions::InvalidParameterError if student.blank?

      @grade = Grade.new(resource_params.merge(student_id: student.id))
    end
  end
end
