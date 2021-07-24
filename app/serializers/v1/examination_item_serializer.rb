# frozen_string_literal: true
module V1
  # ExaminationItemSerializer
  class ExaminationItemSerializer < ActiveModel::Serializer
    attributes :id, :name, :score, :average_score
  end
end
