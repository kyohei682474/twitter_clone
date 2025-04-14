# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :body, presence: true, length: { maximum: 280 }

  paginates_per 5
end
