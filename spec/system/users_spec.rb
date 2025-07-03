# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  # サインアップのテスト
  # 正常系
  # 正しい値を入力してサインアップする
  describe 'User registration' do
    context 'with valid information' do
      scenario 'create a new user' do
        user = FactoryBot.build(:user)
        expect do
          sign_up_as(user)
        end.to change(User, :count).by(1)
      end

      scenario 'redirect to login page after sign up' do
        user = FactoryBot.build(:user)
        sign_up_as(user)
        expect(page).to have_content('ログインしてください')
      end
    end

    # 異常系
    context 'with invalid information' do
      scenario 'fail to create user with incorrect email' do
        user = FactoryBot.build(:user)
        expect do
          sign_up_as(user, email: '333example.com')
        end.not_to change(User, :count)
      end

      scenario 'fails to sign up with an invalid email format' do
        user = FactoryBot.build(:user)
        sign_up_as(user, email: '333example.com')
        expect(page).to have_content('メールアドレスは不正な値です')
      end

      scenario 'fail to create user with nil email' do
        user = FactoryBot.build(:user)
        expect do
          sign_up_as(user, email: '')
        end.not_to change(User, :count)
      end

      scenario 'shows an error when email is left blank during sign up' do
        user = FactoryBot.build(:user)
        sign_up_as(user, email: '')
        expect(page).to have_content('メールアドレスを入力してください')
      end

      scenario 'fail to create a user when mail is already in use' do
        user = FactoryBot.create(:user, email: 'user333@example.com')
        expect do
          sign_up_as(user, email: 'user333@example.com')
        end.not_to change(User, :count)
      end

      scenario 'shows an error when email is already in use' do
        user = FactoryBot.create(:user, email: 'user333@example.com')
        sign_up_as(user, email: 'user333@example.com')
        expect(page).to have_content('メールアドレスはすでに存在します')
      end

      scenario 'fail to create a user when phone_number is blank' do
        user = FactoryBot.build(:user)
        expect do
          sign_up_as(user, phone_number: '')
        end.not_to change(User, :count)
      end

      scenario 'shows an error when phone number is blank' do
        user = FactoryBot.build(:user)
        sign_up_as(user, phone_number: '')
        expect(page).to have_content('電話番号を入力してください')
      end

      scenario 'fail to ceate a user when incorrect birthdate' do
        user = FactoryBot.build(:user)
        expect do
          sign_up_as(user, birthdate: Time.zone.today + 1.day)
        end.not_to change(User, :count)
      end

      scenario 'shows an error when the birthdate is invalid' do
        user = FactoryBot.build(:user)
        sign_up_as(user, birthdate: Time.zone.today + 1.day)
        expect(page).to have_content('誕生日は未来の日付にできません')
      end

      scenario 'fail to create a user due to password confirmation mismatch' do
        user = FactoryBot.build(:user)
        expect do
          sign_up_as(user, password_confirmation: 'password!')
        end.not_to change(User, :count)
      end

      scenario 'show as error when pasword confirmation mismatch' do
        user = FactoryBot.build(:user)
        sign_up_as(user, password_confirmation: 'password!')
        expect(page).to have_content('パスワード確認とパスワードの入力が一致しません')
      end

      scenario 'fail to create a user due to Password is too short' do
        user = FactoryBot.build(:user)
        expect do
          sign_up_as(user, password: 'pass')
        end.not_to change(User, :count)
      end

      scenario 'shows an error when password is too short' do
        user = FactoryBot.build(:user)
        sign_up_as(user, password: 'pass')
        expect(page).to have_content('パスワードは6文字以上で入力してください')
      end
    end
  end

  describe 'User login' do
    context 'with valid credentials' do
      scenario 'logs in successfully' do
        visit
      end
    end
  end
end
