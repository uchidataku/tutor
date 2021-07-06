# frozen_string_literal: true
# ApplicationMailer
class ApplicationMailer < ActionMailer::Base
  default from: 'Tutor <tutor@example.com>'
  layout 'mailer'
end
