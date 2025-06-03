# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  # 通知機能
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :user, presence: true
  validates :body, presence: true
end
