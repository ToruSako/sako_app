require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  include SessionsHelper

   let(:user) { create(:user) }

  describe "GET /logout" do
    it "ログインとログアウトが成功すること" do
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

    it "ログアウトが２度行われないこと" do
      get login_path
      post login_path, params: {
        session: {
          email: user.email,
          password: user.password
        }
      }

    end
  end
end
