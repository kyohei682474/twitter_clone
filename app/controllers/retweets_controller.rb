class RetweetsController < ApplicationController
  before_action :authenticate_user!
  def create
    original = Tweet.find(params[:tweet_id]) # リツイート元のツイートを取得
    current_user.tweets.build(retweeted_from: original) unless current_user.tweets.exists?(retweeted_from: original)
    redirect_to root_path, notice: 'リツイートしました'
  end

  def destroy
    # カレントユーザのリツイートした内容を削除する
    @retweet = current_user.tweets.find_by(retweeted_from_id: params[:id])
    if @retweet
      @retweet.destroy
      redirect_to root_path, notice: 'リツイートを解除しました'
    else
      redirect_to root_path, alert: 'リツイートが見つかりませんでした'
    end
  end
end
