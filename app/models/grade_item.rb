# frozen_string_literal: true
# GradeItem
class GradeItem < ApplicationRecord
  belongs_to :grade

  validates :name, :score, presence: true
end
