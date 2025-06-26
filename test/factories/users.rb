FactoryBot.define do
  factory :user do
    name { 'Test' }
    email { 'users123@exapmple.com' }
    password { 'password' }
    phone_number { '012343333' }
    birthdate { Date.new(1989, 11, 11) }
  end
end
