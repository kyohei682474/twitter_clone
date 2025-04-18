# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

JAPANESE_SENTENCES = [
  '今日はとてもいい天気ですね。',
  '最近Rubyの勉強を始めました。',
  'このアプリはすごく使いやすいです。',
  'おはようございます！',
  '週末はのんびり過ごしました。',
  '明日は友達とカフェに行きます。',
  'Railsのマイグレーションって便利ですね。',
  '今日は何をつぶやこうかな？'
].freeze

User.destroy_all
Tweet.destroy_all

# ユーザーの作成
10.times do |i|
  user = User.create!(
    email: "user#{i}@example.com",
    password: 'password',
    password_confirmation: 'password',
    phone_number: Faker::PhoneNumber.cell_phone,
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    confirmed_at: Time.current
  )

  3.times do
    user.tweets.create!(
      body: JAPANESE_SENTENCES.sample
    )
  end
end
# ユーザーのフォロー関係を作成
User.all.find_each do |user|
  other_users = User.where.not(id: user.id) # 自分自身をフォローしないようにする
  followings = other_users.sample(rand(10)) # ランダムに10人をフォロー
  followings.each do |followed_user|
    user.active_relationships.create(followed_id: followed_user.id)
  end
end
Rails.logger.debug ' ユーザーとツイートのデータを作成しました。'
