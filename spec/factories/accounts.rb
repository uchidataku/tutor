# frozen_string_literal: true
FactoryBot.define do
  factory :account do
    sequence(:email) { |n| "test_#{n}@example.com" }
    sequence(:username) { |n| "user#{n}" }
    password { 'password' }
    birthday { '2000-01-01' }
    last_notification_read_at { Time.zone.now }
  end
end
