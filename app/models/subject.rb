# frozen_string_literal: true
# Subject
class Subject < ApplicationRecord
  module Classification
    JUNIOR_HIGH_SCHOOL = 'junior_high_school' # 中学校
    HIGH_SCHOOL = 'high_school' # 高等学校
  end

  enum classification: { junior_high_school: 0, high_school: 1 }, _suffix: true

  validates :name, presence: true, uniqueness: true
end
