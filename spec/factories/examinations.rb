# frozen_string_literal: true
FactoryBot.define do
  factory :examination do
    name { '中間考査' }
    classification { Tutor::StudentClassification::JUNIOR_HIGH_SCHOOL }
    school_year { 2 }
    semester { Tutor::Semester::FIRST_SEMESTER }

    association :student
  end
end
