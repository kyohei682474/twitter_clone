# frozen_string_literal: true

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'ユーザーログインの時' do
    let(:valid_attributes) do
      { name: 'Test User',
        email: 'user1234@example.com',
        password: 'password',
        phone_number: '012345678',
        birthdate: Date.new(1999, 11, 12) }
    end

    let(:user) { User.new(valid_attributes) }

    # 名前、メールアドレス、パスワード、電話番号、誕生日があれば有効のユーザー
    it 'is valid with a name, email, password, phone_number and birthday' do
      expect(user).to be_valid
    end

    # 名前が無くても有効のユーザー
    it 'is valid with a nil name' do
      user.name = nil
      expect(user).to be_valid
    end

    # 同じ電話番号のユーザーは無効
    it 'is invalid with the same phone number' do
      user = FactoryBot.create(:user, phone_number: valid_attributes[:phone_number])
      other_user = User.new(valid_attributes.merge(email: 'something@.uniquremailcom'))
      expect(other_user).to be_invalid
    end

    # 同じメールアドレスのユーザーは無効
    it 'is invalid with the same email' do
      user = FactoryBot.create(:user, email: valid_attributes[:email])
      other_user = User.new(valid_attributes.merge(phone_number: '999999999'))
      expect(other_user).to be_invalid
    end

    # パスワードが5文字以下のユーザーが無効
    it 'is invalid with a password shorter than 6 characters' do
      user.password = 'passw'
      expect(user).to be_invalid
    end

    # 誕生日が未記入のユーザーは無効
    it 'is invalid with a nil birthdate' do
      user.birthdate = nil
      expect(user).to be_invalid
    end
  end
end
