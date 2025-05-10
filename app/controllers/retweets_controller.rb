class RetweetsController < ApplicationController
  before_action :authenticate_user!
  def create
    original = Tweet.find(params[:tweet_id]) # リツイート元のツイートを取得
    current_user.tweets.build(retweeted_from: original) unless current_user.tweets.exists?(retweeted_from: original)
    redirect_to root_path, notice: 'リツイートしました'
  end

  def destroy
  end
end
