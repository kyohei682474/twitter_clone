# frozen_string_literal: true

class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @tweet = Tweet.find(params[:tweet_id])
    current_user.bookmarked_tweets << @tweet unless current_user.bookmarked_tweets.include?(@tweet)
    flash.now[:notice] = 'ブックマークしました'
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tweet_path(@tweet), notice: 'ブックマークしました' }
    end
  end

  def destroy
    @tweet = Tweet.find(params[:tweet_id])
    current_user.bookmarked_tweets.destroy(@tweet)
    flash.now[:alert] = 'ブックマークを解除しました'
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tweet_path(@tweet), alert: 'ブックマークを解除しました' }
    end
  end

  def index
    @tweets = current_user.bookmarked_tweets.includes(:user) # 明確な理由がわかっていなので調べる
  end
end
