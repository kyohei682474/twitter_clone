# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'
require 'open-uri'

AVATAR_IMAGE_URL = 'https://twitter-clone-images-for-kyohei.s3.ap-northeast-1.amazonaws.com/avater_image.jpg'
HEADER_IMAGE_URL = 'https://twitter-clone-images-for-kyohei.s3.ap-northeast-1.amazonaws.com/header_image.jpg'

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
tweets = []
users = []
# ユーザーの作成
10.times do |i| # rubocop:disable Metrics/BlockLength
  user = User.create!(
    name: "ユーザー#{i}",
    email: "user#{i}@example.com",
    password: 'password',
    password_confirmation: 'password',
    location: Faker::Address.city,
    # bio: Faker::Lorem.sentence(word_count: 10),
    bio: "test#{i}test#{i}test#{i}test#{i}",
    phone_number: Faker::PhoneNumber.cell_phone,
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    website: "example#{i}.com",
    confirmed_at: Time.current
  )

  user.header_image.attach(
    io: URI.open('https://twitter-clone-images-for-kyohei.s3.ap-northeast-1.amazonaws.com/header_image.jpg'),
    filename: 'header_image.jpg',
    content_type: 'image/jpeg'
  )
  user.avatar_image.attach(
    io: URI.open('https://twitter-clone-images-for-kyohei.s3.ap-northeast-1.amazonaws.com/avater_image.jpg'),
    filename: 'avatar_image.jpg',
    content_type: 'image/jpeg'
  )
  # usersに作成したuserを格納
  users << user

  tweet = user.tweets.create!(
    body: JAPANESE_SENTENCES.sample
  )

  tweets << tweet
  tweet.comments.create!(user: user, body: JAPANESE_SENTENCES.sample)
  tweet.likes.create!(user: user)
  user.tweets.create!(body: tweet.body, retweeted_from: tweet)
  user
end
# ユーザーのフォロー関係を作成
User.all.find_each do |user|
  other_users = User.where.not(id: user.id) # 自分自身をフォローしないようにする
  followings = other_users.sample(rand(10)) # ランダムに10人をフォロー
  followings.each do |followed_user|
    user.active_relationships.create(followed_id: followed_user.id)
  end
end

users.first(3).each do |liked_user|
  tweet = tweets.sample
  next if tweet.user == liked_user

  like = Like.create!(user: liked_user, tweet: tweet)
  Notification.create!(
    recipient: tweet.user,
    actor: liked_user,
    notifiable: like,
    action_type: 'like'
  )
end

users.last(3).each do |comment_user|
  tweet = tweets.sample
  next if tweet.user == comment_user

  puts comment_user.class
  comment = tweet.comments.create!(user: comment_user, body: JAPANESE_SENTENCES.sample)
  Notification.create!(
    recipient: tweet.user,
    actor: comment_user,
    notifiable: comment,
    action_type: 'comment'
  )
end

users.last(3).each do |retweet_user|
  tweet = tweets.sample
  next if tweet.user == retweet_user

  retweet = retweet_user.tweets.create!(body: tweet.body, retweeted_from: tweet)
  Notification.create!(
    recipient: tweet.user,
    actor: retweet_user,
    notifiable: retweet,
    action_type: 'retweet'
  )
end
puts 'seedファイルを作成しました'
