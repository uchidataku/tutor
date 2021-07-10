# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::TutorsController, type: :request do
  let!(:account) { create(:account) }
  let(:headers) { { Authorization: "Bearer #{account.jwt}" } }

  describe 'GET /v1/accounts/:account_id/tutor' do
    subject(:request) { get v1_account_tutor_path(account.id), headers: headers }
    let!(:tutor) { create(:tutor, account: account) }

    it 'アカウントのTutorが取得できること' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq tutor.id
    end
  end

  describe 'POST /v1/accounts/:account_id/tutor' do
    subject(:request) { post v1_account_tutor_path(account.id), params: params, headers: headers }
    let(:params) do
      { tutor: { first_name: '太郎',
                 last_name: '田中',
                 first_name_kana: 'タロウ',
                 last_name_kana: 'タナカ',
                 username: 'tanaka',
                 birthday: '2020-01-01' } }
    end

    context 'EmailVerificationStatusがverifiedの場合' do
      let!(:update_account) { account.update(email_verification_status: Account::EmailVerificationStatus::VERIFIED) }

      it 'アカウントのTutorが作成できること' do
        expect { request }.to change(Tutor, :count).by(+1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'EmailVerificationStatusがverified以外の場合' do
      it '作成できないこと' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH /v1/accounts/:account_id/tutor' do
    subject(:request) { patch v1_account_tutor_path(target_account.id), params: params, headers: headers }
    let(:params) { { tutor: { username: 'hey' } } }
    let!(:tutor) { create(:tutor, account: account) }

    context '自分のアカウントの場合' do
      let(:target_account) { account }

      it 'アカウントのTutorが更新されること' do
        request
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['username']).to eq 'hey'
      end
    end

    context '他人のアカウントの場合' do
      let(:target_account) { other_account }
      let!(:tutor) { create(:tutor, account: other_account) }
      let(:other_account) { create(:account) }

      it '更新できないこと' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
