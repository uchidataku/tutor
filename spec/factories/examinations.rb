# frozen_string_literal: true
FactoryBot.define do
  factory :examination do
    name { '中間考査' }
    classification { Examination::Classification::JUNIOR_HIGH_SCHOOL }
    school_year { 2 }
    semester { Examination::Semester::FIRST_SEMESTER }
  end
end
