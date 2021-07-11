# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::AcademicHistoriesController, type: :request do
  let(:account) { create(:account) }
  let(:headers) { { 'Authorization' => "Bearer #{account.jwt}" } }

  describe 'GET /v1/accounts/:account_id/tutor/academic_histories' do
    subject(:request) { get v1_account_tutor_academic_histories_path(account.id), headers: headers }
    let!(:academic_histories) { create_list(:academic_history, 3, tutor: tutor) }
    let!(:other_academic_histories) { create_list(:academic_history, 3, tutor: other_tutor) }
    let(:tutor) { create(:tutor, account: account) }
    let(:other_tutor) { create(:tutor) }

    it 'チューターの学歴一覧を取得できる' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body.count).to eq 3
    end
  end

  describe 'POST /v1/accounts/:account_id/tutor/academic_histories' do
    subject(:request) { post v1_account_tutor_academic_histories_path(target_account.id), params: params, headers: headers }
    let(:params) do
      { academic_history: { name: '早稲田大学',
                            faculty: '商学部',
                            since_date: '2020-04-01',
                            classification: AcademicHistory::Classification::UNIVERSITY,
                            is_attended: true } }
    end

    context '自分のアカウントの場合' do
      let(:target_account) { account }
      let!(:tutor) { create(:tutor, account: target_account) }

      it '学歴を作成できる' do
        expect { request }.to change(AcademicHistory, :count).by(+1)
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

  describe 'GET /v1/academic_histories/:id' do
    subject(:request) { get v1_academic_history_path(academic_history.id), headers: headers }
    let(:academic_history) { create(:academic_history, tutor: tutor) }
    let!(:tutor) { create(:tutor, account: account) }

    it '学歴を取得できる' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq academic_history.id
    end
  end

  describe 'PATCH /v1/academic_histories/:id' do
    subject(:request) { patch v1_academic_history_path(academic_history.id), params: params, headers: headers }
    let!(:academic_history) { create(:academic_history, tutor: tutor) }
    let(:tutor) { create(:tutor, account: target_account) }
    let(:params) { { academic_history: { faculty: '情報学部' } } }

    context '自分の学歴の場合' do
      let(:target_account) { account }

      it '学歴を更新できる' do
        request
        expect(response).to have_http_status(:ok)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['faculty']).to eq '情報学部'
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

  describe 'DELETE /v1/academic_histories/:id' do
    subject(:request) { delete v1_academic_history_path(academic_history.id), headers: headers }
    let!(:academic_history) { create(:academic_history, tutor: tutor) }
    let(:tutor) { create(:tutor, account: target_account) }

    context '自分の学歴の場合' do
      let(:target_account) { account }

      it '学歴を削除できる' do
        expect { request }.to change(AcademicHistory, :count).by(-1)
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
