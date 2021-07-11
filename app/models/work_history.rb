# frozen_string_literal: true
# WorkHistory
class WorkHistory < ApplicationRecord
  belongs_to :tutor

  validates :name, :since_date, presence: true
  validates :is_employed, inclusion: [true, false]
end
