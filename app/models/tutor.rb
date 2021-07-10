# frozen_string_literal: true
# Tutor
class Tutor < ApplicationRecord
  belongs_to :account

  validates :first_name, :last_name, :first_name_kana, :last_name_kana, :username, :birthday, presence: true
end
