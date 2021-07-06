# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::AccountsController, type: :request do
  let!(:account) { create(:account) }
  let(:headers) { { Authorization: "Bearer #{account.jwt}" } }

  describe 'GET /v1/accounts/:id' do
    subject(:request) { get v1_account_path(account.id), headers: headers }

    it 'アカウントが取得できること' do
      request
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq account.id
    end
  end

  describe 'PATCH /v1/accounts/:id' do
    subject(:request) { patch v1_account_path(target_account.id), params: params, headers: headers }

    context '自分のアカウントの場合' do
      let(:target_account) { account }

      context 'email更新' do
        context '入力されたアドレスは未登録のもの' do
          let(:params) { { account: { email: 'hoge@example.com' } } }

          xit 'アドレス確認メールが送信されること'
        end

        context '入力されたアドレスは既に登録済みのもの' do
          let(:params) { { account: { email: 'hoge@example.com' } } }
          let!(:account) { create(:account, email: 'hoge@example.com') }

          it 'アドレス確認メールが送信に失敗すること' do
            request
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      context 'password更新' do
        context '新パスワードと確認用が一致' do
          let(:params) do
            { account: { current_password: 'password',
                         new_password: 'newpassword',
                         new_password_confirmation: 'newpassword' } }
          end

          it 'アカウントのパスワードが再設定されること' do
            request
            expect(target_account.password_digest).not_to eq target_account.reload.password_digest
          end
        end

        context '新パスワードと確認用が不一致' do
          let(:params) do
            { account: { current_password: 'password',
                         new_password: 'newpassword',
                         new_password_confirmation: 'failpassword' } }
          end

          it 'パスワードの再設定に失敗すること' do
            request
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context '現在のパスワードが不一致' do
          let(:params) do
            { account: { current_password: 'failpassword',
                         new_password: 'newpassword',
                         new_password_confirmation: 'newpassword' } }
          end

          it 'パスワードの再設定に失敗すること' do
            request
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end

    context '他人のアカウントの場合' do
      let(:target_account) { create(:account) }
      let(:params) { { account: { email: 'hoge@example.com' } } }

      it 'アカウントを更新できないこと' do
        request
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /v1/accounts/:id' do
    subject(:request) { delete v1_account_path(target_account.id), headers: headers }

    context '自分のアカウント' do
      let!(:target_account) { account }

      it '削除できること' do
        expect { request }.to change(Account, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context '他人のアカウント' do
      let!(:target_account) { create(:account) }

      it '削除できないこと' do
        expect { request }.not_to change(Account, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
