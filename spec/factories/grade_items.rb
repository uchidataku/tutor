# frozen_string_literal: true
FactoryBot.define do
  factory :grade_item do
    name { '数学' }
    score { 5 }

    association :grade
  end
end
