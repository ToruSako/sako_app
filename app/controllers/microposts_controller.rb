class MicropostsController < ApplicationController

  before_action :logged_in_user, only: [:create, :show, :edit, :update, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @user = current_user
    @micropost = current_user.microposts.build(micropost_params) if logged_in?
    @microposts = @user.microposts.page(params[:page]).per(10)

    if @micropost.save
      flash[:success] = "投稿しました"
      redirect_to root_url
    else
      flash[:warning] = "投稿に失敗しました"
      redirect_to root_url
    end
  end

  def edit
    @micropost = current_user.microposts.find_by(id: params[:id]) || nil
    if @micropost.nil?
      flash[:warning] = "編集権限がありません"
      redirect_to root_url
    end
  end

  def update
    @micropost = current_user.microposts.find_by(id: params[:id])
    @micropost.update_attributes(micropost_params)
    if @micropost.save
      flash[:success] = "編集が完了しました"
      redirect_to root_url
    else
      render 'microposts/edit'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "ログが削除されました"
    redirect_to current_user
  end

  def show
    @micropost = Micropost.find(params[:id])
    @like = Like.new
  end

  def index
    @microposts = Micropost.all.order(created_at: :desc)
    @microposts = Micropost.page(params[:page]).per(20)
  end

  private

   def micropost_params
     params.require(:micropost).permit(:memo, :picture)
   end

   def correct_user
     @micropost = current_user.microposts.find_by(id: params[:id])
     redirect_to root_url if @micropost.nil?
   end
end
