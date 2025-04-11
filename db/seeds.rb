# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

User.destroy_all
Tweet.destroy_all

# ユーザーの作成
10.times do |i|
  user = User.create!(
    email: "user#{i}@example.com",
    password: 'password',
    password_confirmation: 'password'
  )

  3.times do
    user.tweets.create!(
      body: Faker::Lorem.sentence(word_count: rand(5..15))
    )
  end
end

puts ' ユーザーとツイートのデータを作成しました。'
