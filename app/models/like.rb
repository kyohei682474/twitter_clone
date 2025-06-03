# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  # 通知機能
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates :user_id, uniqueness: { scope: :tweet_id }
end
