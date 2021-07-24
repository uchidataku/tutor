# frozen_string_literal: true
FactoryBot.define do
  factory :examination_item do
    name { '数学' }
    score { 80 }
    average_score { 56.8 }

    association :examination
  end
end
