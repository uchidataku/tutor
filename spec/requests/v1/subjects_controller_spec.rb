# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::SubjectsController, type: :request do
  let!(:account) { create(:account) }
  let(:headers) { { Authorization: "Bearer #{account.jwt}" } }

  describe 'GET /v1/subjects' do
    subject(:request) { get v1_subjects_path, headers: headers }
    let!(:subject_count) { Subject.count }
    let!(:subjects) { create_list(:subject, 3) }

    it '科目一覧が取得できること' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body.count).to eq (subject_count + 3)
    end
  end
end
