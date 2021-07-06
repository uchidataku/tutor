# frozen_string_literal: true
module URL
  module FrontEndUrls
    FRONT_APP_HOST = ENV.fetch('APP_HOST').gsub('api.', '').gsub('api-', '').freeze

    EMAIL_CONFIRMED_URL = "https://#{FRONT_APP_HOST}/mail_confirmed"
  end
end
