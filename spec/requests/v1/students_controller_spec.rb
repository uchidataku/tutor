# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::StudentsController, type: :request do
  let!(:account) { create(:account) }
  let(:headers) { { Authorization: "Bearer #{account.jwt}" } }

  describe 'GET /v1/accounts/:account_id/student' do
    subject(:request) { get v1_account_student_path(account.id), headers: headers }
    let!(:student) { create(:student, account: account) }

    it 'アカウントのStudentが取得できること' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq student.id
    end
  end

  describe 'POST /v1/accounts/:account_id/student' do
    subject(:request) { post v1_account_student_path(account.id), params: params, headers: headers }
    let(:params) do
      { student: { username: 'hogehoge',
                   birthday: '2020-01-01',
                   junior_high_school_name: 'サンプル中学校',
                   current_classification: Student::CurrentClassification::JUNIOR_HIGH_SCHOOL,
                   current_school_year: 2 } }
    end

    context 'EmailVerificationStatusがverifiedの場合' do
      let!(:update_account) { account.update(email_verification_status: Account::EmailVerificationStatus::VERIFIED) }

      it 'アカウントのStudentが作成できること' do
        expect { request }.to change(Student, :count).by(+1)
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

  describe 'PATCH /v1/accounts/:account_id/student' do
    subject(:request) { patch v1_account_student_path(target_account.id), params: params, headers: headers }
    let(:params) { { student: { username: 'hey' } } }
    let!(:student) { create(:student, account: account) }

    context '自分のアカウントの場合' do
      let(:target_account) { account }

      it 'アカウントのStudentが更新されること' do
        request
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['username']).to eq 'hey'
      end
    end

    context '他人のアカウントの場合' do
      let(:target_account) { other_account }
      let!(:student) { create(:student, account: other_account) }
      let(:other_account) { create(:account) }

      it '更新できないこと' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
