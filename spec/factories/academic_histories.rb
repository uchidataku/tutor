# frozen_string_literal: true
FactoryBot.define do
  factory :academic_history do
    name { '明治大学' }
    faculty { '法学部' }
    since_date { '2000-04-01' }
    until_date { '2004-03-01' }
    classification { AcademicHistory::Classification::UNIVERSITY }
    is_attended { false }

    association :tutor
  end
end
