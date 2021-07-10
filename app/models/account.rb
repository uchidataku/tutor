# frozen_string_literal: true
# Account
class Account < ApplicationRecord
  include JWT::Authenticatable

  has_secure_password

  module EmailVerificationStatus
    UNSPECIFIED = 'unspecified'
    REQUESTED = 'requested'
    VERIFIED = 'verified'
  end

  # Associations
  has_one :student, dependent: :destroy
  has_one :tutor, dependent: :destroy
  has_many :jtis, dependent: :destroy

  # Enum
  enum email_verification_status: { unspecified: 0, requested: 1, verified: 2 }, _suffix: true

  # Validates
  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
end
