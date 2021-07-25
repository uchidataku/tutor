# frozen_string_literal: true
# Grade
class Grade < ApplicationRecord
  belongs_to :student

  # Tutor::StudentClassificationに対応
  enum classification: { junior_high_school: 0, high_school: 1, technical_college: 2 }, _suffix: true
  # Tutor::Semesterに対応
  enum semester: { first_semester: 0,
                   second_semester: 1,
                   third_semester: 2,
                   first_term: 3,
                   last_term: 4 }, _suffix: true

  validates :name, :school_year, presence: true
end
