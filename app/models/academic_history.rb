# frozen_string_literal: true
# AcademicHistory
class AcademicHistory < ApplicationRecord
  module Classification
    UNIVERSITY = 'university'
    GRADUATE_SCHOOL = 'graduate_school'
    TECHNICAL_COLLEGE = 'technical_college'
    VOCATIONAL_SCHOOL = 'vocational_school'
    JUNIOR_COLLEGE = 'junior_college'
    HIGH_SCHOOL = 'high_school'
    JUNIOR_HIGH_SCHOOL = 'junior_high_school'
  end

  belongs_to :tutor

  enum classification: {
    university: 0, # 大学
    graduate_school: 1, # 大学院
    technical_college: 2, # 高等専門学校
    vocational_school: 3, # 専門学校
    junior_college: 4, # 短期大学
    high_school: 5, # 高等学校
    junior_high_school: 6 # 中学校
  }, _suffix: true

  validates :name, :since_date, presence: true
  validates :until_date, presence: true, if: -> { is_attended == false }
  validates :is_attended, inclusion: [true, false]
end
