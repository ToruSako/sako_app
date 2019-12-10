require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  include SessionsHelper

  let(:user) { create(:user) }

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
