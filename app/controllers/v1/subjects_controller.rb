# frozen_string_literal: true
module V1
  # SubjectsController
  class SubjectsController < ApplicationController
    load_and_authorize_resource

    def index
      render json: @subjects
    end
  end
end
