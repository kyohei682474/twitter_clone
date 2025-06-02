# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :users, through: :entries

  def other_user_for(user)
    users.where.not(id: user.id).first || users.first
  end

  def self.room_user_pairs(user)
    user.rooms.includes(:users, :chats).map do |room|
      other_user = room.other_user_for(user)
      next unless other_user

      [room, other_user]
    end.to_h
  end
end
