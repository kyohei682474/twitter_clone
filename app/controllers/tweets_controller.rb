# frozen_string_literal: true

class TweetsController < ApplicationController
  before_action :authenticate_user!, only: %i[create show]
  def create
    @user = current_user
    @tweets = Tweet.all.includes(:user).order(created_at: :desc).page(params[:page])
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      flash[:notice] = 'ツイートが作成されました'
      redirect_to root_path
    else
      flash.now[:alert] = 'ツイートに失敗しました'
      render 'home/index', status: :unprocessable_entity # 明示的い失敗したとステータス示すことによりエラーメッセージを表示
    end
  end

  def show
    @tweet = Tweet.find(params[:id])
    @user = @tweet.user
    @comments = @tweet.comments.includes(:user) # user情報を含んでいるtweetのcomment
    @comment = @tweet.comments.build(user: current_user) # Comment.new(user: current_user)のかわり
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body, :image)
  end
end
