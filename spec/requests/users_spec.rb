# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:valid_attributes) do
    {
      name: 'Test User',
      email: '1user@example.com',
      password: 'password',
      password_confirmation: 'password',
      phone_number: '0123456789000000',
      birthdate: Date.new(1990, 1, 1)
    }
  end

  describe 'POST/ users' do
    # 正しいパラメータで登録したとき
    context 'with valid parameters' do
      # １人ユーザーが増える
      it 'create a new user' do
        expect do
          post user_registration_path, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      # メールが送信されているかを確認
      it 'sends confirmation mail' do
        ActionMailer::Base.deliveries.clear
        post user_registration_path, params: { user: valid_attributes }
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to include('1user@example.com')
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
      # ユーザーを追加することができない
      it 'does not create user' do
        expect do
          post user_registration_path, params: { user: valid_attributes.merge(email: '') }
        end.not_to change(User, :count)
      end
    end

    # 同じメールアドレスを送信するとき
    context 'when register the same email' do
      before do
        @user = FactoryBot.create(:user, email: '2user@example.com')
      end

      # ユーザーを追加することができない
      it 'does not create user' do
        expect do
          post user_registration_path, params: { user: valid_attributes.merge(email: '2user@example.com') }
        end.not_to change(User, :count)
      end

      # 同じemailが含まれているとエラーメッセージが得られる
      it 'shows error when email is already taken' do
        post user_registration_path, params: { user: valid_attributes.merge(email: '2user@example.com') }
        expect(response.body).to include('メールアドレスはすでに存在します')
      end
    end

    # 空のパスワードを送信するとき
    context 'when send blank password' do
      # ユーザーを追加できない
      it 'does not create user' do
        expect do
          post user_registration_path, params: { user: valid_attributes.merge(password: '') }
        end.not_to change(User, :count)
      end
    end

    # 6文字未満のパスワードを送信するとき
    context 'when send less than 6 length passowrd' do
      # ユーザ登録できない
      it 'does not create user' do
        expect do
          post user_registration_path, params: { user: valid_attributes.merge(password: 'short') }
        end.not_to change(User, :count)
      end

      # パスワードは6文字以上で入力してくださいとメッセージが生じる
      it 'shows error when password is shorter than 6 characters' do
        post user_registration_path, params: { user: valid_attributes.merge(password: 'short') }
        expect(response.body).to include('パスワードは6文字以上で入力してください')
      end
    end

    # パスワードと確認用のパスワードが違うとき
    context 'when password comfirmation does not match' do
      # ユーザー登録できない
      it 'does not create user' do
        expect do
          post user_registration_path,
               params: { user: valid_attributes.merge(password_confirmation: 'differentpassword') }
        end.not_to change(User, :count)
      end

      # パスワード確認とパスワードの入力が一致しませんとエラーメッセージが生じる
      it 'shows error when password confirmation does not match password' do
        post user_registration_path,
             params: { user: valid_attributes.merge(password_confirmation: 'differentpassword') }
        expect(response.body).to include('パスワード確認とパスワードの入力が一致しません')
      end
    end
  end

  # GitHubを使用してサインアップ
  describe 'GET /users/auth/github/callback' do
    context 'when GitHub returns valid user info' do
      before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
          provider: 'github',
          uid: '1234',
          info: {
            name: 'GitHub User',
            email: 'github@example.com'
          }
        )
      end

      # githubでログインしてなければ、githubでログインできる
      it 'create a user if not exsits' do
        expect do
          get user_github_omniauth_callback_path
        end.to change(User, :count).by(1)
      end

      it 'redirect to root path' do
        get user_github_omniauth_callback_path
        expect(response).to redirect_to(root_path)
      end

      it 'displays success message after sign up' do
        get user_github_omniauth_callback_path
        follow_redirect!
        expect(response.body).to include('ログインしました')
      end

      # もしgitubユーザー存存在していると新しいユーザー作成されない。
      it 'does not create user if already exists' do
        FactoryBot.create(:user, email: 'github@example.com', provider: 'github', uid: '123456')
        expect do
          get user_github_omniauth_callback_path
        end.not_to change(User, :count)
      end

      it 'redirect to new_user_registration_path' do
        FactoryBot.create(:user, email: 'github@example.com', provider: 'github', uid: '123456')
        get user_github_omniauth_callback_path
        expect(response).to redirect_to(new_user_registration_path)
      end
    end

    # 不正なクレデンシャルを持つGitHubアカウンを持つとき
    context 'when GitHub returns invalid credential' do
      before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:github] = :invaild_credentials
      end

      it 'redirects to the sign up page with alert' do
        get user_github_omniauth_callback_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'displays faild message after sign in' do
        get user_github_omniauth_callback_path
        follow_redirect!
        expect(response.body).to include('認証に失敗しました')
      end
    end
  end

  describe 'POST/users/sign_in' do
    before do
      FactoryBot.create(:user, email: 'user9999@example.com', password: 'password')
    end

    context 'with valid credential' do
      # ログインしてルートページにリダイレクトする
      it 'logs in and redirects to root_path' do
        post user_session_path, params: {
          user: {
            email: 'user9999@example.com',
            password: 'password'
          }
        }
        expect(response).to redirect_to(root_path)
      end

      # 302のステータスコードを返す
      it 'response status 302' do
        post user_session_path, params: {
          user: {
            email: 'user9999@example.com',
            password: 'password'
          }
        }
        expect(response).to have_http_status(302)
      end
    end

    # 誤った情報を使用するとき
    context 'with invalid credential' do
      # 存在しないメールアドレス、パスワードでログインしようとするとき
      it ''
    end
  end
end
