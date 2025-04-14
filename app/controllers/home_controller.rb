# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, only: %i[following index]
  def index
    @tweets = Tweet.all.includes(:user).order(created_at: :desc).page(params[:page])
    @tweet = Tweet.new
  end

  def following
    @tweets = Tweet.where(user_id: current_user.followings.ids).includes(:user).order(created_at: :desc).page(params[:page])
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body, :image)
  end
end
