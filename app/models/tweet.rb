# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :retweeted_from, class_name: 'Tweet', optional: true
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :retweets, class_name: 'Tweet', foreign_key: 'retweeted_from_id', dependent: :destroy
  has_one_attached :image
  validates :body, presence: true, length: { maximum: 140 }
  validates :user_id, uniquness: { scope: :retweeted_from_id }, if: -> { retweeted_from_id.present? }

  paginates_per 5

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def liked_from(user)
    likes.find_by(user_id: user.id)
  end
end
