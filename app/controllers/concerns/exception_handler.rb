# frozen_string_literal: true
# 例外対応
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError do |e|
      Rails.logger.fatal e.full_message

      render json: {
        errors: [
          { description: Rails.env.production? ? 'Whoops, looks like something went wrong' : e.message, status: 500 }
        ]
      }, status: :internal_server_error
    end

    rescue_from Exceptions::InvalidParameterError do |e|
      Sentry.capture_exception(e)
      render json: { errors: [{ description: e.message, status: 422 }] }, status: :unprocessable_entity
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { errors: [{ description: e.message, status: 404 }] }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { errors: [{ description: e.message, status: 422 }] }, status: :unprocessable_entity
    end

    rescue_from CanCan::AccessDenied do |e|
      message = "Not authorized to #{e.action} #{e.subject.is_a?(Class) ? e.subject.name : e.subject.class.name}"
      message += ":#{e.subject.id}" if e.subject.respond_to?(:id)

      render json: { errors: [{ description: message, status: 403 }] }, status: :forbidden
    end

    rescue_from ActionController::ParameterMissing do |e|
      render json: { errors: [{ description: e.message, status: 422 }] }, status: :unprocessable_entity
    end

    rescue_from JWT::DecodeError do
      render json: { errors: [{ description: 'Unauthorized', status: 401 }] }, status: :unauthorized
    end

    rescue_from Exceptions::UnauthorizedError do
      render json: { errors: [{ description: 'Unauthorized', status: 401 }] }, status: :unauthorized
    end

    rescue_from Exceptions::InvalidEmailError do
      json_response({ errors: [{ description: '入力されたメールアドレスは既に登録されています。', status: 422 }] },
                    :unprocessable_entity)
    end
  end
end
