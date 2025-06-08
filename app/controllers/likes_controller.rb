# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    @tweet = Tweet.find(params[:tweet_id])
    @like = current_user.likes.build(tweet: @tweet)

    if @like.save
      # サービスクラスを使用して通知の作成とメールの送信まで行う
      NotifyUserService.call(
        actor: current_user,
        recipient: @tweet.user,
        notifiable: @like,
        action_type: 'like'
      )

      flash.now[:notice] = 'いいねしました'
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to tweet_path(@tweet) }
      end

    else
      flash[:alert] = 'いいねに失敗しました'
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    @tweet = Tweet.find(params[:tweet_id])
    @like = current_user.likes.find_by(tweet: @tweet)

    if @like&.destroy
      flash.now[:notice] = 'いいねを解除しました'
      respond_to do |format|
        format.turbo_stream { render 'likes/destroy' }
        format.html { redirect_to tweet_path(@tweet) }
      end
    else
      flash.now[:alert] = 'いいねの解除に失敗しました'
    end
  end
end
