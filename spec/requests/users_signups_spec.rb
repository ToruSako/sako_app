require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  include SessionsHelper

  #間違った情報で登録するメソッド
  def post_invalid_information
  post signup_path, params: {
    user: {
      name: "",
      email: "user@invalid",
      password: "foo",
      password_confirmation: "bar"
    }
  }
end

#正しい情報で登録するメソッド
def post_valid_information
  post signup_path, params: {
    user: {
      name: "Example User",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password"
    }
  }
end

  describe "ユーザ登録にGETし" do
    it "無効な値を渡した場合、ユーザの数が増えないこと" do
      get signup_path
      expect { post_invalid_information }.not_to change(User, :count)
      expect(is_logged_in?).to be_falsey
    end

    it "有効な値を渡した場合、ユーザの数が増えること" do
      get signup_path
      expect { post_valid_information }.to change(User, :count).by(1)
      expect(is_logged_in?).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq '/users/1'
    end
  end
end
