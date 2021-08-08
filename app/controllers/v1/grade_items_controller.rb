# frozen_string_literal: true
module V1
  # GradeItemsController
  class GradeItemsController < ApplicationController
    load_and_authorize_resource :grade
    load_and_authorize_resource through: :grade, shallow: true

    def index
      render json: @grade_items
    end

    def show
      render json: @grade_item
    end

    def create
      @grade_item.save!
      render json: @grade_item, status: :created
    end

    def update
      @grade_item.update!(resource_params)
      render json: @grade_item
    end

    def destroy
      @grade_item.destroy!
      head 204
    end

    private

    def resource_params
      params.require(:grade_item).permit(:name, :score)
    end
  end
end
