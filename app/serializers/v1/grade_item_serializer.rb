# frozen_string_literal: true
module V1
  # GradeItemSerializer
  class GradeItemSerializer < ActiveModel::Serializer
    attributes :id, :name, :score
  end
end
