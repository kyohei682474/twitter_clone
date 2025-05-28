# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :users, through: :entries

  def other_user_for(current_user)
    users.where.not(id: current_user.id).first
  end
end
