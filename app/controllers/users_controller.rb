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
      Rails.logger.debug @user.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  # def follow
  #   @user = User.find(params[:id])
  #   current_user.followings << @user if user != current_user && !current_user.following?(@user)
  #   redirect_to request.referer || root_path, notice: "#{@user.display_name}をフォローしました"
  # end

  # def unfollow
  #   @user = User.find(params[:id])
  #   current_user.followings.delete(@user) if current_user.following?(@user)
  #   redirect_to request.referer || root_path, notice: "#{@user.display_name}のフォローを解除しました"
  # end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :birthdate, :phone_number,
                                 :avatar_image, :profile_image, :header_image, :bio, :location, :website)
  end
end
