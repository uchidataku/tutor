# frozen_string_literal: true
module V1
  # ExaminationSerializer
  class ExaminationSerializer < ActiveModel::Serializer
    attributes :id, :classification, :school_year, :semester

    has_many :grade_items
  end
end
