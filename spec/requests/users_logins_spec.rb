require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  include SessionsHelper

  let(:user) { create(:user) }
  let(:no_activation_user) { create(:no_activation_user) }

  # ログインメソッドを定義
def post_valid_information(login_user, remember_me = 0)
  post login_path, params: {
    session: {
      email: user.email,
      password: user.password,
      remember_me: remember_me
    }
  }
end
  #間違った情報でログインするメソッド
def post_invalid_information
  post login_path, params: {
    session: {
      email: "",
      password: ""
    }
  }
end


  describe "ログインのテスト" do

    it "無効なログイン情報を与えた場合、dangerフラッシュが出ること" do
      get login_path
      post_invalid_information
      expect(flash[:danger]).to be_truthy
      expect(is_logged_in?).to be_falsey
      expect(request.fullpath).to eq '/login'
    end

    # it "有効化されていないアカウントがログインに失敗すること" do
    #  get login_path
    #  post_valid_information(no_activation_user)
    #  expect(flash[:danger]).to be_truthy　
    #  expect(is_logged_in?).to be_falsey
    #  follow_redirect!
    #  expect(request.fullpath).to eq '/'
    # end

   it "dangerフラッシュが出ないこと" do
     get login_path
     post_valid_information(user)
     expect(flash[:danger]).to be_falsey
     expect(is_logged_in?).to be_truthy
     follow_redirect!
     expect(request.fullpath).to eq '/users/1'
   end

   it "ログアウトが成功すること" do
     get login_path
     post_valid_information(user)
     expect(is_logged_in?).to be_truthy
     follow_redirect!
     expect(request.fullpath).to eq '/users/1'
     delete logout_path
     expect(is_logged_in?).to be_falsey
     follow_redirect!
     expect(request.fullpath).to eq '/'
   end

   it "2度ログアウトしないこと" do
     get login_path
     post_valid_information(user)
     expect(is_logged_in?).to be_truthy
     follow_redirect!
     expect(request.fullpath).to eq '/users/1'
     delete logout_path
     expect(is_logged_in?).to be_falsey
     follow_redirect!
     expect(request.fullpath).to eq '/'
     delete logout_path
     follow_redirect!
     expect(request.fullpath).to eq '/'
   end

   it "チェックボックスをオンにしたことでリメンバートークンが保存されること" do
     get login_path
     post_valid_information(user, 1)
     expect(is_logged_in?).to be_truthy
     expect(cookies[:remember_token]).not_to be_empty
   end

   it "リメンバーミーをOFFにしたことでリメンバートークンが空になること" do
    get login_path
    post_valid_information(user, 0)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).to be_nil
   end
 end
end
