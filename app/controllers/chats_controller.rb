class ChatsController < ApplicationController
  before_atction :authenticate_user!

  def create
    @room = Room.find(params[:room_id])
    @chat = @romm.chats.build(chat_params)
    @chat.user = current_user
    if @chat.save
      redirect_to room_path(@room), notice: 'メッセージを送信しました'
    else
      redirect_to room_path(@room), alert: 'メッセージの送信に失敗しました'
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:content)
  end
end
