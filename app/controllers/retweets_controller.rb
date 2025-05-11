class RetweetsController < ApplicationController
  before_action :authenticate_user!
  def create
    original = Tweet.find_by(id: params[:tweet_id])
    return head :not_found unless original

    @retweet = current_user.tweets.find_or_initialize_by(retweeted_from: original)
    Rails.logger.info "Retweet save failed: #{@retweet.errors.full_messages}"
    return head :unprocessable_entity if @retweet.new_record? && !@retweet.save

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, notice: 'リツイートしました' }
    end
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
