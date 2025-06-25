# frozen_string_literal: true

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  #名前、メールアドレス、パスワード、電話番号、誕生日があれば有効のユーザー
  it "is valid with a name, email, password, phone_number and birthday " do
    user = User.new( name: "Test", 
                         email: "users123@exapmple.com",
                         password: "password",
                         phone_number: "012343333",
                         birthdate: Date.new(1989, 11, 11)
                        )
    expect(user).to be_valid
  end
   
  # 名前が無ければ無効なユーザー
  # 同じ電話番号のユーザーは無効
  # 名前が51文字を超えるユーザーは無効
  # パスワードが5文字のユーザーが無効
end
