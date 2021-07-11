# frozen_string_literal: true
FactoryBot.define do
  factory :work_history do
    name { 'Apple株式会社' }
    since_date { '2000-04-01' }
    until_date { '2004-03-01' }
    job_summary { '職務要約' }
    is_employed { false }

    association :tutor
  end
end
