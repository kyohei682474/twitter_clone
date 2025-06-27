# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  before do
    @user = FactoryBot.create(:user)
  end

  describe 'POST/ users' do
    # 正しいパラメータで登録したとき
    context 'with valid parameters' do
      let(:valid_attributes) do
        { name: 'Test User',
          email: 'user1234@example.com',
          password: 'password',
          phone_number: '012345678',
          birthdate: Date.new(1999, 11, 12) }
      end

      # １人ユーザーが増える
      it 'create a new user' do
        expect do
          post user_registration_path, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'returns a 302 ok status' do
        post user_registration_path, params: { user: valid_attributes }
        expect(response).to have_http_status(302)
      end

      # メールが送信されているかを確認
      it 'sends confirmation mail' do
        post user_registration_path, params: { user: valid_attributes }
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to include('user1234@example.com')
      end
    end

    # 無効なパラメータで登録したとき
    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          name: '',
          email: '',
          password: 'pass',
          phone_number: '',
          birthdate: Date.new(1999, 11, 12)
        }
      end

      # 新規でユーザーを作成することができない
      it 'does not create user' do
        expect do
          post user_registration_path, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end
    end

    # メールアドレスが空欄のとき
    context 'when blank email' do
      let(:invalid_attributes) do
        {
          name: 'Test User',
          email: '',
          password: 'password',
          phone_number: '01234567890',
          birthdate: Date.new(1989, 1, 1)
        }
      end

      # ユーザーを追加することができない
      it 'does not create user' do
        expect do
          post user_registration_path, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end
    end

    # 同じメールアドレスを登録するとき
    context 'when register the same email' do
      let(:valid_attributes) do
        { name: 'Test User',
          email: 'user1234@example.com',
          password: 'password',
          phone_number: '012345678',
          birthdate: Date.new(1999, 11, 12) }
      end

      # ユーザーを追加することができない
      it 'does not create user' do
        expect do
          post user_registration_path, params: { user: valid_attributes.merge(email: 'users123@exapmple.com') }
        end.not_to change(User, :count)
      end
    end
  end
end
