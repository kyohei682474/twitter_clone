# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @tweets = @user.tweets
    @liked_tweets = @user.liked_tweets.includes(:user)
    @followers = @user.followers
    @retweets = @user.retweet_tweets.includes(:user)
    @comments = @user.comments
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :birthdate, :phone_number,
                                 :avatar_image, :profile_image, :bio, :location, :website)
  end
end
