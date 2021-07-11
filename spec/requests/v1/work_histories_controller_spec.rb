# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::WorkHistoriesController, type: :request do
  let(:account) { create(:account) }
  let(:headers) { { 'Authorization' => "Bearer #{account.jwt}" } }

  describe 'GET /v1/accounts/:account_id/tutor/work_histories' do
    subject(:request) { get v1_account_tutor_work_histories_path(account.id), headers: headers }
    let!(:work_histories) { create_list(:work_history, 3, tutor: tutor) }
    let!(:other_work_histories) { create_list(:work_history, 3, tutor: other_tutor) }
    let(:tutor) { create(:tutor, account: account) }
    let(:other_tutor) { create(:tutor) }

    it 'チューターの学歴一覧を取得できる' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body.count).to eq 3
    end
  end

  describe 'POST /v1/accounts/:account_id/tutor/work_histories' do
    subject(:request) { post v1_account_tutor_work_histories_path(target_account.id), params: params, headers: headers }
    let(:params) do
      { work_history: { name: 'Google株式会社',
                        since_date: '2020-04-01',
                        job_summary: '要約',
                        is_employed: true } }
    end

    context '自分のアカウントの場合' do
      let(:target_account) { account }
      let!(:tutor) { create(:tutor, account: target_account) }

      it '学歴を作成できる' do
        expect { request }.to change(WorkHistory, :count).by(+1)
        expect(response).to have_http_status(:created)
      end
    end

    context '他人のアカウントの場合' do
      let(:target_account) { create(:account) }
      let!(:tutor) { create(:tutor, account: target_account) }
      let!(:my_tutor) { create(:tutor, account: account) }

      it '学歴を作成できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /v1/work_histories/:id' do
    subject(:request) { get v1_work_history_path(work_history.id), headers: headers }
    let(:work_history) { create(:work_history, tutor: tutor) }
    let!(:tutor) { create(:tutor, account: account) }

    it '学歴を取得できる' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq work_history.id
    end
  end

  describe 'PATCH /v1/work_histories/:id' do
    subject(:request) { patch v1_work_history_path(work_history.id), params: params, headers: headers }
    let!(:work_history) { create(:work_history, tutor: tutor) }
    let(:tutor) { create(:tutor, account: target_account) }
    let(:params) { { work_history: { job_summary: 'hoge' } } }

    context '自分の学歴の場合' do
      let(:target_account) { account }

      it '学歴を更新できる' do
        request
        expect(response).to have_http_status(:ok)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['job_summary']).to eq 'hoge'
      end
    end

    context '他人の学歴の場合' do
      let(:target_account) { create(:account) }

      it '学歴を更新できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /v1/work_histories/:id' do
    subject(:request) { delete v1_work_history_path(work_history.id), headers: headers }
    let!(:work_history) { create(:work_history, tutor: tutor) }
    let(:tutor) { create(:tutor, account: target_account) }

    context '自分の学歴の場合' do
      let(:target_account) { account }

      it '学歴を削除できる' do
        expect { request }.to change(WorkHistory, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context '他人の学歴の場合' do
      let(:target_account) { create(:account) }

      it '削除できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
