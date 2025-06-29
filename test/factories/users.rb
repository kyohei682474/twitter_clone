# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Test' }
    email { Faker::Internet.unique.email }
    password { 'password' }
    phone_number { Faker::Number.unique.number(digits: 11).to_s }
    birthdate { Date.new(1989, 10, 17) }
    confirmed_at { Time.current }
  end
end
