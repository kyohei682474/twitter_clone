# frozen_string_literal: true

module SystemHelpers
  def fill_sign_up_form(user, overrides = {})
    email = overrides[:email] || user.email
    phone_number = overrides[:phone_number] || user.phone_number
    birthdate = overrides[:birthdate] || user.birthdate
    password = overrides[:password] || user.password
    password_confirmation = overrides[:password_confirmation] || user.password_confirmation

    fill_in 'メールアドレス', with: email
    fill_in '電話番号', with: phone_number
    select birthdate.year.to_s, from: 'user_birthdate_1i'
    select birthdate.month.to_s, from: 'user_birthdate_2i'
    select birthdate.day.to_s, from: 'user_birthdate_3i'
    fill_in 'パスワード', with: password
    fill_in 'パスワード確認', with: password_confirmation
  end

  def sign_up_as(user, overrides = {})
    visit new_user_registration_path
    fill_sign_up_form(user, **overrides)
    click_button 'Sign up'
  end

  def fill_log_in_form(user, overrides = {})
    email = overrides[:email] || user.email
    password = overrides[:password] || user.password

    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
  end

  def log_in_as(user, overrides = {})
    visit user_session_path
    fill_log_in_form(user, **overrides)
    click_button 'ログイン'
  end

  # def fill_tweet_form(user, overriders = {})
  #   body = overriders[:body] || user.body
  #   fill_in 'tweet_body', with: body
  # end
end
