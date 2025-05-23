# frozen_string_literal: true

class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @tweet = Tweet.find(params[:tweet_id])
    current_user.bookmarked_tweets << @tweet unless current_user.bookmarked_tweets.include?(@tweet)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tweet_path(tweet) }
    end
  end

  def destroy
    @tweet = Tweet.find(params[:tweet_id])
    current_user.bookmarked_tweets.destroy(@tweet)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tweet_path(tweet) }
    end
  end

  def index
    @bookmarkes = current_user.bookmarked_tweets.includes(:user)
    @tweets = current_user.bookmarked_tweets.includes(:user) # 明確な理由がわかっていなので調べる
  end
end
