# frozen_string_literal: true

class RetweetsController < ApplicationController
  before_action :authenticate_user!
  def create
    original = Tweet.find(params[:tweet_id])
    return head :not_found unless original

    @retweet = current_user.tweets.find_or_initialize_by(retweeted_from: original)
    return head :unprocessable_entity unless @retweet.save

    # サービスクラスを使用して通知の作成とメールの送信を行う
    NotifyUserService.call(
      actor: current_user,
      recipient: original.user,
      notifiable: @retweet,
      action_type: 'retweet'
    )

    flash.now[:notice] = 'リツイートしました'
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    # カレントユーザのリツイートした内容を削除する
    @retweet = current_user.tweets.find_by(retweeted_from_id: params[:id])
    return head :not_found unless @retweet

    @retweet.destroy
    # if @retweet
    #   @retweet.destroy
    #   redirect_to root_path, notice: 'リツイートを解除しました'
    # else
    #   redirect_to root_path, alert: 'リツイートが見つかりませんでした'
    # end
    flash.now[:alert] = 'リツイートを解除しました'
    respond_to do |format|
      format.turbo_stream
    end
  end
end
