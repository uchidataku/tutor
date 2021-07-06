# frozen_string_literal: true
# ApplicationController
class ApplicationController < ActionController::API
  include ExceptionHandler

  before_action :authenticate_account!

  attr_reader :current_account

  def authenticate_account!
    @current_jwt = /[Bb]earer (.*)/.match(request.headers[:Authorization] || request.headers[:authorization]).to_a[1]
    fail Exceptions::UnauthorizedError, 'JWTが必要です' unless @current_jwt

    @current_account = Account.authenticate!(@current_jwt)
  end
end
