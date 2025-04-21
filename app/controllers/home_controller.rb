# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, only: %i[following index]
  def index
    @user = current_user
    @tweets = Tweet.all.includes(:user).order(created_at: :desc).page(params[:page])
    @tweet = Tweet.new
  end

  def following
    @user = current_user
    @tweets = Tweet.where(user_id: current_user.following_ids)
                   .includes(user: { avatar_image_attachment: :blob })
                   .order(created_at: :desc)
                   .page(params[:page]).per(5)
    # @following_users = current_user.following.includes(:tweets, avatar_image_attachment: :blob)
    #                                .order(created_at: :desc)
    #                                .page(params[:page])

    # @tweets = Tweet.where(user_id: current_user.followings.ids)
    #                .includes(:user)
    #                .order(created_at: :desc)
    #                .page(params[:page])
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body, :image)
  end
end
