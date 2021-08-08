# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::ExaminationsController, type: :request do
  let(:account) { create(:account) }
  let(:headers) { { 'Authorization' => "Bearer #{account.jwt}" } }

  describe 'GET /v1/accounts/:account_id/student/examinations' do
    subject(:request) { get v1_account_student_examinations_path(account.id), headers: headers }
    let!(:examinations) { create_list(:examination, 3, student: student) }
    let!(:other_examinations) { create_list(:examination, 3, student: other_student) }
    let(:student) { create(:student, account: account) }
    let(:other_student) { create(:student) }

    it '生徒の試験一覧を取得できる' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body.count).to eq 3
    end
  end

  describe 'POST /v1/accounts/:account_id/student/examinations' do
    subject(:request) { post v1_account_student_examinations_path(target_account.id), params: params, headers: headers }
    let(:params) do
      { examination: { name: '中間考査',
                       classification: TutorCommon::StudentClassification::JUNIOR_HIGH_SCHOOL,
                       school_year: 2,
                       semester: TutorCommon::Semester::SECOND_SEMESTER } }
    end

    context '自分のアカウントの場合' do
      let(:target_account) { account }
      let!(:student) { create(:student, account: target_account) }

      it '試験を作成できる' do
        expect { request }.to change(Examination, :count).by(+1)
        expect(response).to have_http_status(:created)
      end
    end

    context '他人のアカウントの場合' do
      let(:target_account) { create(:account) }
      let!(:student) { create(:student, account: target_account) }
      let!(:my_student) { create(:student, account: account) }

      it '試験を作成できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /v1/examinations/:id' do
    subject(:request) { get v1_examination_path(examination.id), headers: headers }
    let(:examination) { create(:examination, student: student) }
    let!(:student) { create(:student, account: account) }
    let!(:examination_items) { create_list(:examination_item, 3, examination: examination) }

    it '試験を取得できる' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq examination.id
    end
  end

  describe 'PATCH /v1/examinations/:id' do
    subject(:request) { patch v1_examination_path(examination.id), params: params, headers: headers }
    let!(:examination) { create(:examination, student: student) }
    let(:student) { create(:student, account: target_account) }
    let(:params) { { examination: { name: 'hoge試験' } } }

    context '自分の試験の場合' do
      let(:target_account) { account }

      it '試験を更新できる' do
        request
        expect(response).to have_http_status(:ok)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['name']).to eq 'hoge試験'
      end
    end

    context '他人の試験の場合' do
      let(:target_account) { create(:account) }

      it '試験を更新できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /v1/examinations/:id' do
    subject(:request) { delete v1_examination_path(examination.id), headers: headers }
    let!(:examination) { create(:examination, student: student) }
    let(:student) { create(:student, account: target_account) }

    context '自分の試験の場合' do
      let(:target_account) { account }

      it '試験を削除できる' do
        expect { request }.to change(Examination, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context '他人の試験の場合' do
      let(:target_account) { create(:account) }

      it '削除できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
