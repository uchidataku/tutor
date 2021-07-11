# frozen_string_literal: true
# Tutor
class Tutor < ApplicationRecord
  # Associations
  has_one_attached :avatar

  has_many :academic_histories, dependent: :destroy
  has_many :work_histories, dependent: :destroy
  belongs_to :account

  # Validation
  validates :first_name, :last_name, :first_name_kana, :last_name_kana, :username, :birthday, presence: true

  def avatar_url
    url_for(avatar)
  end
end
