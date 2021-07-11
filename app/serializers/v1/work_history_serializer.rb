# frozen_string_literal: true
module V1
  # WorkHistorySerializer
  class WorkHistorySerializer < ActiveModel::Serializer
    attributes :id,
               :name,
               :since_date,
               :until_date,
               :job_summary,
               :is_employed
  end
end
