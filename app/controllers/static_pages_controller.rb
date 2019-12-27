class StaticPagesController < ApplicationController

  def home
    @microposts_all = Micropost.includes(:user)
    @microposts_all = Micropost.all.order(created_at: :desc)
    @microposts_all = Micropost.page(params[:page]).per(10)

    @user = current_user
    @follow_users = @user ? @user.followings : []
    @follower_microposts = @microposts_all.where(user_id: @follow_users).order("created_at DESC").page(params[:page]).per(10)

    @likes = @user ? Like.where(user_id: @user.id).page(params[:page]).per(10) :[]
  end

  def help
  end

  def about
  end

end
