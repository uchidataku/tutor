# frozen_string_literal: true
# ApplicationRecord
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def url_for(object)
    Rails.application.routes.url_helpers.url_for(object)
  rescue StandardError
    nil
  end
end
