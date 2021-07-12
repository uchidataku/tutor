# frozen_string_literal: true
# Examination
class Examination < ApplicationRecord
  module Classification
    JUNIOR_HIGH_SCHOOL = 'junior_high_school' # 中学校
    HIGH_SCHOOL = 'high_school' # 高等学校
    TECHNICAL_COLLEGE = 'technical_college' # 高等専門学校
  end

  module Semester
    FIRST_SEMESTER = 'first_semester' # 1学期
    SECOND_SEMESTER = 'second_semester' # 2学期
    THIRD_SEMESTER = 'third_semester' # 3学期
    FIRST_TERM = 'first_term' # 前期
    LAST_TERM = 'last_term' # 後期
  end

  enum classification: { junior_high_school: 0, high_school: 1, technical_college: 2 }, _suffix: true
  enum semester: { first_semester: 0,
                   second_semester: 1,
                   third_semester: 2,
                   first_term: 3,
                   last_term: 4 }, _suffix: true

  validates :name, :school_year, presence: true
end
