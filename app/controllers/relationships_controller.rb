# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @user = User.find(params[:user_id])
    current_user.followings << @user if @user != current_user && !current_user.following?(@user)
    redirect_to request.referer || root_path, notice: "#{@user.display_name}をフォローしました"
  end

  def destroy
    # relationshipのidを取得して、relationshipをdestroyする
    relationship = current_user.active_relationships.find(params[:id])
    relationship.destroy
    redirect_to request.referer || root_path, notice: "#{relationship.followed.display_name}のフォローを解除しました"
  end
end
