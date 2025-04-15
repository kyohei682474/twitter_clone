class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @tweets = @user.tweets
    @likes = @user.liked_tweets
    @retweets = @user.retweets
    @comments = @user.comments
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :birthdate, :phone_number,
                                 :avatar_image, :profile_image, :bio, :location, :website)
  end
end
