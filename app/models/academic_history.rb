# frozen_string_literal: true
# AcademicHistory
class AcademicHistory < ApplicationRecord
  module Classification
    UNIVERSITY = 'university' # 大学
    GRADUATE_SCHOOL = 'graduate_school' # 大学院
    TECHNICAL_COLLEGE = 'technical_college' # 高等専門学校
    VOCATIONAL_SCHOOL = 'vocational_school' # 専門学校
    JUNIOR_COLLEGE = 'junior_college' # 短期大学
    HIGH_SCHOOL = 'high_school' # 高等学校
    JUNIOR_HIGH_SCHOOL = 'junior_high_school' # 中学校
  end

  belongs_to :tutor

  enum classification: {
    university: 0,
    graduate_school: 1,
    technical_college: 2,
    vocational_school: 3,
    junior_college: 4,
    high_school: 5,
    junior_high_school: 6
  }, _suffix: true

  validates :name, :since_date, presence: true
  validates :until_date, presence: true, if: -> { is_attended == false }
  validates :is_attended, inclusion: [true, false]
end
