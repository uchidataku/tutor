# frozen_string_literal: true
module V1
  # ExaminationItemsController
  class ExaminationItemsController < ApplicationController
    load_and_authorize_resource :examination
    load_and_authorize_resource :examination_items, through: :examination, shallow: true

    def index
      render json: @examination_items
    end

    def show
      render json: @examination_item
    end

    def create
      @examination_item.save!
      render json: @examination_item, status: :created
    end

    def update
      @examination_item.update!(resource_params)
      render json: @examination_item
    end

    def destroy
      @examination_item.destroy!
      head 204
    end

    private

    def resource_params
      params.require(:examination_item).permit(:name, :score, :average_score)
    end
  end
end
