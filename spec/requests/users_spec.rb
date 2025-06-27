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

    # 空のemailを送信するとき
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

    # 同じメールアドレスを送信するとき
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

      # 同じemailが含まれているとエラーメッセージが得られる
      it 'shows error when email is already taken' do
        post user_registration_path, params: { user: valid_attributes.merge(email: 'users123@exapmple.com') }
        expect(response.body).to include('メールアドレスはすでに存在します')
      end
    end

    # 空のパスワードを送信するとき
    context 'when send blank password' do
      let(:invalid_attributes) do
        { name: 'Test User',
          email: 'user999@example.com',
          password: '',
          phone_number: '01234567890',
          birthdate: Date.new(1989, 1, 1) }
      end

      # ユーザーを追加できない
      it 'does not create user' do
        expect do
          post user_registration_path, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end
    end

    # 6文字未満のパスワードを送信するとき
    context 'when send less than 6 length passowrd' do
      let(:invalid_attributes) do
        { name: 'Test User',
          email: 'user999@example.com',
          password: 'passw',
          phone_number: '01234567890',
          birthdate: Date.new(1989, 1, 1) }
      end

      # ユーザ登録できない
      it 'does not create user' do
        expect do
          post user_registration_path, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end

      # パスワードは6文字以上で入力してくださいとメッセージが生じる
      it 'shows error when password is shorter than 6 characters' do
        post user_registration_path, params: { user: invalid_attributes }
        expect(response.body).to include('パスワードは6文字以上で入力してください')
      end
    end

    # パスワードと確認用のパスワードが違うとき
    context 'when password comfirmation does not match' do
      let(:invalid_attributes) do
        {
          name: 'Test User',
          email: 'user999@example.com',
          password: 'password',
          password_confirmation: 'different_password',
          phone_number: '01234567890',
          birthdate: Date.new(1989, 1, 1)
        }
      end

      # ユーザー登録できない
      it 'does not create user' do
        expect do
          post user_registration_path, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end

      # パスワード確認とパスワードの入力が一致しませんとエラーメッセージが生じる
      it 'shows error when password confirmation does not match password' do
        post user_registration_path, params: { user: invalid_attributes }
        expect(response.body).to include('パスワード確認とパスワードの入力が一致しません')
      end
    end
  end
end
