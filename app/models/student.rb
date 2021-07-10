# frozen_string_literal: true
# Student
class Student < ApplicationRecord
  module CurrentClassification
    JUNIOR_HIGH_SCHOOL = 'junior_high_school' # 中学校
    HIGH_SCHOOL = 'high_school' #高等学校
    TECHNICAL_COLLEGE = 'technical_college' # 高等専門学校
  end

  enum current_classification: { junior_high_school: 0, high_school: 1, technical_college: 2 }, _suffix: true

  validates :username, presence: true, uniqueness: true
  validates :birthday, presence: true
end
