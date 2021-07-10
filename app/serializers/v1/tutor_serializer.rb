# frozen_string_literal: true
module V1
  # TutorSerializer
  class TutorSerializer < ActiveModel::Serializer
    attributes :id,
               :first_name,
               :last_name,
               :first_name_kana,
               :last_name_kana,
               :username,
               :birthday,
               :introduction,
               :phone,
               :address,
               :avatar_url
  end
end
