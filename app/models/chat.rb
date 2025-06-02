# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :content, presence: true
end
