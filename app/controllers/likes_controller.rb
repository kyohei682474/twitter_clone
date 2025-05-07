# frozen_string_literal: true

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
    # if @like.save
    #   respond_to do |format|
    #     format.turbo_stream
    #     format.html { redirect_back fallback_location: root_path, notice: 'いいねしました' }
    #   end
    # else
    #   flash[:alert] = 'いいねに失敗しました'
    #   redirect_back fallback_location: root_path
    # end
  end

  def destroy
    @tweet = Tweet.find(params[:tweet_id])
    @like = current_user.likes.find_by(tweet: @tweet)
    if @like.destroy
      flash[:notice] = 'いいねを解除しました'
      redirect_to tweet_path(@tweet)
    else
      flash[:alert] = 'いいねの解除に失敗しました'
    end
  end
end
