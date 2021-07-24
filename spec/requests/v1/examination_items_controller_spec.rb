# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::ExaminationItemsController, type: :request do
  let(:account) { create(:account) }
  let(:headers) { { 'Authorization' => "Bearer #{account.jwt}" } }

  describe 'GET /v1/examinations/:examination_id/examination_items' do
    subject(:request) { get v1_examination_examination_items_path(examination.id), headers: headers }
    let!(:examination_items) { create_list(:examination_item, 3, examination: examination) }
    let!(:other_examination_items) { create_list(:examination_item, 3, examination: other_examination) }
    let(:examination) { create(:examination, student: student) }
    let(:other_examination) { create(:examination, student: other_student) }
    let(:student) { create(:student, account: account) }
    let(:other_student) { create(:student) }

    it '生徒の試験一覧を取得できる' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body.count).to eq 3
    end
  end

  describe 'POST /v1/examinations/:examination_id/examination_items' do
    subject(:request) { post v1_examination_examination_items_path(examination.id), params: params, headers: headers }
    let(:params) do
      { examination_item: { name: '数学', score: 96, averrage_score: 57.8 } }
    end
    let!(:examination) { create(:examination, student: student) }

    context '自分の試験の場合' do
      let(:target_account) { account }
      let!(:student) { create(:student, account: target_account) }

      it '試験結果項目を作成できる' do
        expect { request }.to change(ExaminationItem, :count).by(+1)
        expect(response).to have_http_status(:created)
      end
    end

    context '他人のアカウントの場合' do
      let(:target_account) { create(:account) }
      let!(:student) { create(:student, account: target_account) }
      let!(:my_student) { create(:student, account: account) }

      it '試験結果項目を作成できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /v1/examination_items/:id' do
    subject(:request) { get v1_examination_item_path(examination_item.id), headers: headers }
    let!(:examination_item) { create(:examination_item, examination: examination) }
    let(:examination) { create(:examination, student: student) }
    let(:student) { create(:student, account: account) }

    it '試験結果項目を取得できる' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq examination_item.id
    end
  end

  describe 'PATCH /v1/examination_items/:id' do
    subject(:request) { patch v1_examination_item_path(examination_item.id), params: params, headers: headers }
    let!(:examination_item) { create(:examination_item, examination: examination) }
    let(:examination) { create(:examination, student: student) }
    let(:student) { create(:student, account: target_account) }
    let(:params) { { examination_item: { name: '英語' } } }

    context '自分の試験の場合' do
      let(:target_account) { account }

      it '試験結果項目を更新できる' do
        request
        expect(response).to have_http_status(:ok)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['name']).to eq '英語'
      end
    end

    context '他人の試験の場合' do
      let(:target_account) { create(:account) }

      it '試験結果項目を更新できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /v1/examination_items/:id' do
    subject(:request) { delete v1_examination_item_path(examination_item.id), headers: headers }
    let!(:examination_item) { create(:examination_item, examination: examination) }
    let(:examination) { create(:examination, student: student) }
    let(:student) { create(:student, account: target_account) }

    context '自分の試験の場合' do
      let(:target_account) { account }

      it '試験結果項目を削除できる' do
        expect { request }.to change(ExaminationItem, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context '他人の試験の場合' do
      let(:target_account) { create(:account) }

      it '試験結果項目できない' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
