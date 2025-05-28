# frozen_string_literal: true

class ChatsController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(params[:room_id])
    @chat = @room.chats.build(chat_params)
    @chat.user = current_user
    if @chat.save
      redirect_to room_path(@room), notice: 'メッセージを送信しました'
    else
      @chats = @room.chats.includes(:user)
      render 'rooms/show', staus: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:content)
  end
end
