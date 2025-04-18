# frozen_string_literal: true

class TweetsController < ApplicationController
  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      flash[:notice] = 'ツイートが作成されました'
      redirect_to root_path
    else
      flash[:alert] = 'ツイートに失敗しました'
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body, :image)
  end
end
