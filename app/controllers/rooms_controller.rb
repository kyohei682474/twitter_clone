class RoomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @rooms = current_user.rooms.includes(:chats, :users)
    @room_user_pairs = current_user.rooms.includes(:users, :chats).map do |room|
      other_user = room.other_user_for(current_user)
      [room, other_user]
    end.uniq { |_, other_user| other_user.id }
  end

  def show
    @room = Room.find(params[:id])
    redirect_to rooms_path, alert: 'アクセス権がありません' unless @room.users.include?(current_user)
    @chats = @room.chats.includes(:user).order(created_at: :asc)
    @chat = @room.chats.build
  end

  # drpdownアイコンからダイレクトメッセージをクリックする際に遷移するアクション
  def create
    reception_user = User.find(params[:user_id])
    # 自分と相手ユーザーの２人が参加しているルームを探す
    @room = Room.joins(:entries)
                .where(entries: { user_id: [current_user.id, reception_user.id] })
                .group('rooms.id')
                .having('COUNT(DISTINCT entries.user_id) = 2')
                .first
    # ルームが見つからなければ新規作成
    unless @room
      @room = Room.create
      @room.entries.create!(user: current_user)
      @room.entries.create!(user: reception_user)
    end

    redirect_to room_path(@room)
  end
end
