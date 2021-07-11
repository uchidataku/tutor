# frozen_string_literal: true
module V1
  # AcademicHistorySerializer
  class AcademicHistorySerializer < ActiveModel::Serializer
    attributes :id,
               :name,
               :faculty,
               :since_date,
               :until_date,
               :classification,
               :is_attended
  end
end
