# frozen_string_literal: true
# Account
class Account < ApplicationRecord
  has_secure_password

  module EmailVerificationStatus
    UNSPECIFIED = 'unspecified'
    REQUESTED = 'requested'
    VERIFIED = 'verified'
  end

  # Enum
  enum email_verification_status: { unspecified: 0, requested: 1, verified: 2 }, _suffix: true

  # Validates
  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
end
