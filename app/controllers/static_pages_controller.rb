class StaticPagesController < ApplicationController
  def home
    @allmicroposts = Micropost.all.order(created_at: :desc)
    @allmicroposts = Micropost.page(params[:page]).per(10)
  end

  def help
  end

  def about
  end

end
