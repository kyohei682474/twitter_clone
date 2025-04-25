# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[show edit update destroy] # rubocop:disable Rails/LexicallyScopedActionFilter
  def show
    @user = current_user
    @tweets = @user.tweets
    @liked_tweets = @user.liked_tweets.includes(:user)
    @followers = @user.followers
    @retweets = @user.retweet_tweets.includes(:user)
    @comments = @user.commented_tweets.includes(:user)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールを更新しました'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :birthdate, :phone_number,
                                 :avatar_image, :profile_image, :bio, :location, :website)
  end
end
