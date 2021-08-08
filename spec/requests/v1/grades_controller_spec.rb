# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::GradesController, type: :request do
  let(:account) { create(:account) }
  let(:headers) { { 'Authorization' => "Bearer #{account.jwt}" } }

  describe 'GET /v1/accounts/:account_id/student/grades' do
    subject(:request) { get v1_account_student_grades_path(account.id), headers: headers }
    let!(:grades) { create_list(:grade, 3, student: student) }
    let!(:other_grades) { create_list(:grade, 3, student: other_student) }
    let(:student) { create(:student, account: account) }
    let(:other_student) { create(:student) }

    it '生徒の成績一覧を取得できる' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body.count).to eq 3
    end
  end

  describe 'POST /v1/accounts/:account_id/student/grades' do
    subject(:request) { post v1_account_student_grades_path(target_account.id), params: params, headers: headers }
    let(:params) do
      { grade: { classification: TutorCommon::StudentClassification::JUNIOR_HIGH_SCHOOL,
                 school_year: 2,
                 semester: TutorCommon::Semester::SECOND_SEMESTER } }
    end

    context '自分のアカウントの場合' do
      let(:target_account) { account }
      let!(:student) { create(:student, account: target_account) }

      it '成績を作成できる' do
        expect { request }.to change(Grade, :count).by(+1)
        expect(response).to have_http_status(:created)
      end
    end

    context '他人のアカウントの場合' do
      let(:target_account) { create(:account) }
      let!(:student) { create(:student, account: target_account) }
      let!(:my_student) { create(:student, account: account) }

      it '成績を作成できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /v1/grades/:id' do
    subject(:request) { get v1_grade_path(grade.id), headers: headers }
    let(:grade) { create(:grade, student: student) }
    let!(:student) { create(:student, account: account) }
    let!(:grade_items) { create_list(:grade_item, 3, grade: grade) }

    it '成績を取得できる' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq grade.id
    end
  end

  describe 'PATCH /v1/grades/:id' do
    subject(:request) { patch v1_grade_path(grade.id), params: params, headers: headers }
    let!(:grade) { create(:grade, student: student) }
    let(:student) { create(:student, account: target_account) }
    let(:params) { { grade: { school_year: 3 } } }

    context '自分の成績の場合' do
      let(:target_account) { account }

      it '成績を更新できる' do
        request
        expect(response).to have_http_status(:ok)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['school_year']).to eq 3
      end
    end

    context '他人の成績の場合' do
      let(:target_account) { create(:account) }

      it '成績を更新できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /v1/grades/:id' do
    subject(:request) { delete v1_grade_path(grade.id), headers: headers }
    let!(:grade) { create(:grade, student: student) }
    let(:student) { create(:student, account: target_account) }

    context '自分の成績の場合' do
      let(:target_account) { account }

      it '成績を削除できる' do
        expect { request }.to change(Grade, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context '他人の成績の場合' do
      let(:target_account) { create(:account) }

      it '削除できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
