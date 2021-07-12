# frozen_string_literal: true
# ExaminationItem
class ExaminationItem < ApplicationRecord
  belongs_to :examination

  validates :name, :score, presence: true
end
