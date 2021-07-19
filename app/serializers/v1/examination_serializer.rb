# frozen_string_literal: true
module V1
  # ExaminationSerializer
  class ExaminationSerializer < ActiveModel::Serializer
    attributes :id,
               :name,
               :classification,
               :school_year,
               :semester
  end
end
