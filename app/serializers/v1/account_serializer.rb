# frozen_string_literal: true
module V1
  # AccountSerializer
  class AccountSerializer < ActiveModel::Serializer
    attributes :id, :email, :email_verification_status, :last_sign_in_at, :last_notification_read_at
  end
end
