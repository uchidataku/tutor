# frozen_string_literal: true
module V1
  # StudentSerializer
  class StudentSerializer < ActiveModel::Serializer
    attributes :id,
               :username,
               :birthday,
               :introduction,
               :junior_high_school_name,
               :high_school_name,
               :technical_school_name,
               :current_classification,
               :current_school_year,
               :avatar_url
  end
end
