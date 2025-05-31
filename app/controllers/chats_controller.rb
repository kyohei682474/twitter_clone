class ChatsController < ApplicationController
  before_atction :authenticate_user!

  def create
    @chat = currenst_user.chats.new(chat_params)
    @chat.room_id = params[:room_id]
    if @chat.save
      redirect_to room_path(@chat.room), notice: 'Chat was successfully created.'
    else
      redirect_to room_path(@chat.room), alert: 'Error creating chat.'
    end
  end
end
