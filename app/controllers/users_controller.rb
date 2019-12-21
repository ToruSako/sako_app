class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,   only: :destroy


  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end


  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "認証用メールを送信しました。メールアドレスを確認して、本登録を完了させてください。"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'プロフィールの更新に成功しました'
      redirect_to edit_user_path(@user)
    else
      flash.now[:danger] = 'プロフィールの編集に失敗しました'
      redirect_to edit_user_path(@user)
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザを削除しました"
    redirect_to root_url
  end

  private

     def user_params
       params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :profile, :picture)
     end

     def correct_user
       @user = User.find(params[:id])
       redirect_to(root_url) unless current_user?(@user)
     end

     def admin_user
       redirect_to(root_url) unless current_user.admin?
     end
end
