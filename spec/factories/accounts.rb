# frozen_string_literal: true
FactoryBot.define do
  factory :account do
    sequence(:email) { |n| "test_#{n}@example.com" }
    password { 'password' }
    last_notification_read_at { Time.zone.now }
  end
end
