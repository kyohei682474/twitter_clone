# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  validates :user, presence: true
  validates :body, presence: true
end
