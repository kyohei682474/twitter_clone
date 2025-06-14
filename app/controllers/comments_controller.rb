# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  # POST /tweets/:tweet_id/comments
  # コメントを作成するアクション
  def create
    @tweet = Tweet.find(params[:tweet_id])
    @comment = @tweet.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      # 通知の作成のメールの送信をサービスクラスで行う。
      NotifyUserService.call(
        actor: current_user,
        recipient: @tweet.user,
        notifiable: @comment,
        action_type: 'comment'
      )

      redirect_to tweet_path(@tweet), notice: 'コメントが投稿されました'

    else
      redirect_to tweet_path(@tweet), alert: 'コメントの投稿に失敗しました'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
