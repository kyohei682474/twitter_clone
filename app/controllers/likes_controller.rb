class LikesController < ApplicationController
  def create
    @tweet = Tweet.find(params[:tweet_id])
    @like = current_user.likes.build(tweet: @tweet)
    if @like.save
      flash[:notice] = 'いいねしました'
      redirect_to tweet_path(@tweet)
    else
      flash[:alert] = 'いいねいに失敗しました'
    end
  end

  def destroy
    @tweet = Tweet.find(params[:tweet_id])
  end
end
