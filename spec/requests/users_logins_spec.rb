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

  it "sessions/newにアクセスできること" do
    #ログインページにアクセスします
    get login_path
    expect(response).to have_http_status(:success)
  end

  describe "ログインページにアクセスした時" do
    it "無効なログイン情報を与えた場合、dangerフラッシュが出ること" do
      post login_path
      post login_path, params: {
      session: {
         email: "",
         password: ""
       }
     }
     expect(flash[:danger]).to be_truthy
     expect(logged_in?).to be_falsey
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



   it "有効なログイン情報を与えた場合、dangerフラッシュが出ないこと" do
     get login_path
     post login_path, params: {
       session: {
         email: user.email,
         password: user.password
       }
     }
     expect(flash[:danger]).to be_falsey
     expect(logged_in?).to be_truthy
   end
   it "succeeds login and logout" do
        get login_path
        post login_path, params: {
          session: {
            email: user.email,
            password: user.password
          }
        }
        expect(is_logged_in?).to be_truthy
        delete logout_path
        expect(is_logged_in?).to be_falsey
   end
 end

end
