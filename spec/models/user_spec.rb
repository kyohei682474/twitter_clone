# frozen_string_literal: true

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'ユーザーログインの時' do
    let(:valid_attirbutes) do
      { name: 'Test',
        email: 'user123@example.com',
        password: 'password',
        phone_number: '012345678',
        birthdate: Date.new(1989, 11, 11) }
    end

    let(:user) { User.new(valid_attirbutes) }

    # 名前、メールアドレス、パスワード、電話番号、誕生日があれば有効のユーザー
    it 'is valid with a name, email, password, phone_number and birthday' do
      expect(user).to be_valid
    end

    # 名前が無くても有効のユーザー
    it 'is valid with a nil name' do
      user = User.new(name: nil,
                      email: 'users123@exapmple.com',
                      password: 'password',
                      phone_number: '012343333',
                      birthdate: Date.new(1989, 11, 11))
      expect(user).to be_valid
    end

    # 同じ電話番号のユーザーは無効
    it 'is invalid with the same phone number' do
      user = FactoryBot.create(:user)
      other_user = User.new(name: 'test1',
                            email: 'users1234@exapmple.com',
                            password: 'password',
                            phone_number: '012343333',
                            birthdate: Date.new(1989, 11, 11))
      expect(other_user).to be_invalid
    end

    # 同じメールアドレスのユーザーは無効
    it 'is invalid with the same email' do
      user = FactoryBot.create(:user)
      other_user = User.new(name: 'test1',
                            email: 'users123@exapmple.com',
                            password: 'password',
                            phone_number: '012343337',
                            birthdate: Date.new(1989, 11, 11))
      expect(other_user).to be_invalid
    end

    # パスワードが5文字以下のユーザーが無効
    it 'is invalid with a password shorter than 6 characters' do
      user = User.create(name: 'Test2',
                         email: 'users123@exapmple.com',
                         password: 'passw',
                         phone_number: '012333333',
                         birthdate: Date.new(1989, 11, 11))
      expect(user).to be_invalid
    end

    # 誕生日が未記入のユーザーは無効
    it 'is invalid with a nil birthdate' do
      user = User.create(name: 'Test2',
                         email: 'users123@exapmple.com',
                         password: 'password',
                         phone_number: '012333333',
                         birthdate: nil)
      expect(user).to be_invalid
    end
  end
end
