# frozen_string_literal: true
FactoryBot.define do
  factory :tutor do
    first_name { '一郎' }
    last_name { '鈴木' }
    first_name_kana { 'イチロウ' }
    last_name_kana { 'スズキ' }
    username { 'イチロー' }
    birthday { '2000-01-01' }
    introduction { '自己紹介' }
    phone { '09012345678' }
    address { '東京都' }

    association :account
  end
end
