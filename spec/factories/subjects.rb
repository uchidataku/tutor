# frozen_string_literal: true
FactoryBot.define do
  factory :subject do
    sequence(:name) { |n| "科目_#{n}" }
    classification { Subject::Classification::JUNIOR_HIGH_SCHOOL }
  end
end
