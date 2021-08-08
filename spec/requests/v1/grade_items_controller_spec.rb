# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::GradeItemsController, type: :request do
  let(:account) { create(:account) }
  let(:headers) { { 'Authorization' => "Bearer #{account.jwt}" } }

  describe 'GET /v1/grades/:grade_id/grade_items' do
    subject(:request) { get v1_grade_grade_items_path(grade.id), headers: headers }
    let!(:grade_items) { create_list(:grade_item, 3, grade: grade) }
    let!(:other_grade_items) { create_list(:grade_item, 3, grade: other_grade) }
    let(:grade) { create(:grade, student: student) }
    let(:other_grade) { create(:grade, student: other_student) }
    let(:student) { create(:student, account: account) }
    let(:other_student) { create(:student) }

    it '生徒の成績一覧を取得できる' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body.count).to eq 3
    end
  end

  describe 'POST /v1/grades/:grade_id/grade_items' do
    subject(:request) { post v1_grade_grade_items_path(grade.id), params: params, headers: headers }
    let(:params) do
      { grade_item: { name: '数学', score: 96, averrage_score: 57.8 } }
    end
    let!(:grade) { create(:grade, student: student) }

    context '自分の成績の場合' do
      let(:target_account) { account }
      let!(:student) { create(:student, account: target_account) }

      it '成績結果項目を作成できる' do
        expect { request }.to change(GradeItem, :count).by(+1)
        expect(response).to have_http_status(:created)
      end
    end

    context '他人のアカウントの場合' do
      let(:target_account) { create(:account) }
      let!(:student) { create(:student, account: target_account) }
      let!(:my_student) { create(:student, account: account) }

      it '成績結果項目を作成できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /v1/grade_items/:id' do
    subject(:request) { get v1_grade_item_path(grade_item.id), headers: headers }
    let!(:grade_item) { create(:grade_item, grade: grade) }
    let(:grade) { create(:grade, student: student) }
    let(:student) { create(:student, account: account) }

    it '成績結果項目を取得できる' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq grade_item.id
    end
  end

  describe 'PATCH /v1/grade_items/:id' do
    subject(:request) { patch v1_grade_item_path(grade_item.id), params: params, headers: headers }
    let!(:grade_item) { create(:grade_item, grade: grade) }
    let(:grade) { create(:grade, student: student) }
    let(:student) { create(:student, account: target_account) }
    let(:params) { { grade_item: { name: '英語' } } }

    context '自分の成績の場合' do
      let(:target_account) { account }

      it '成績結果項目を更新できる' do
        request
        expect(response).to have_http_status(:ok)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['name']).to eq '英語'
      end
    end

    context '他人の成績の場合' do
      let(:target_account) { create(:account) }

      it '成績結果項目を更新できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /v1/grade_items/:id' do
    subject(:request) { delete v1_grade_item_path(grade_item.id), headers: headers }
    let!(:grade_item) { create(:grade_item, grade: grade) }
    let(:grade) { create(:grade, student: student) }
    let(:student) { create(:student, account: target_account) }

    context '自分の成績の場合' do
      let(:target_account) { account }

      it '成績結果項目を削除できる' do
        expect { request }.to change(GradeItem, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context '他人の成績の場合' do
      let(:target_account) { create(:account) }

      it '成績結果項目できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
