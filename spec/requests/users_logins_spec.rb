require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  include SessionsHelper

  let(:user) { create(:user) }

  # ログインメソッドを定義
def post_valid_information(remember_me = 0)
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
   context "無効な情報を与えた時" do
    it "無効なログイン情報を与えた場合、dangerフラッシュが出ること" do
      get login_path
      post_invalid_information
      expect(flash[:danger]).to be_truthy
      expect(is_logged_in?).to be_falsey
    end
  end

   context "有効な情報を与えた時" do
   it "dangerフラッシュが出ないこと" do
     get login_path
     post_valid_information
     expect(flash[:danger]).to be_falsey
     expect(is_logged_in?).to be_truthy
     follow_redirect!
     expect(request.fullpath).to eq '/users/1'
   end

   it "ログアウトが成功すること" do
     get login_path
     post_valid_information
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
     post_valid_information
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
     post_valid_information(1)
     expect(is_logged_in?).to be_truthy
     expect(cookies[:remember_token]).not_to be_empty
   end

   it "リメンバーミーをOFFにしたことでリメンバートークンが空になること" do
    get login_path
    post_valid_information(0)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).to be_nil
   end
 end
end
end 
