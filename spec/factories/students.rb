# frozen_string_literal: true
FactoryBot.define do
  factory :student do
    sequence(:username) { |n| "student_#{n}" }
    birthday { '2000-01-01' }
    introduction { '自己紹介' }
    junior_high_school_name { 'hoge中学校' }
    high_school_name { 'hoge高等学校' }
    current_classification { Student::CurrentClassification::HIGH_SCHOOL }
    current_school_year { 2 }
  end
end
