require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  user = FactoryBot.create(:user)
  # サインアップのテスト
  # 正常系
  # 正しい値を入力してサインアップする
  scenario 'logs in successfully' do
    visit 'users/sign_up'
    fill_in 'メールアドレス', with: user.email
    fill_in '電話番号', with: user.phone_number
    select user.birthdate.year.to_s, from: 'user_birthdate_1i'
    select user.birthdate.month.to_s, from: 'user_birthdate_2i'
    select user.birthdate.day.to_s,   from: 'user_birthdate_3i'
    fill_in 'パスワード', with: user.password
    fill_in 'パスワード確認', with: user.password_confirmation
    click_button 'Sign up'
  end
end
