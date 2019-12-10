require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  describe "ユーザ登録にGETし" do
    it "無効な値を渡した場合、ユーザの数が増えないこと" do
      get signup_path
      expect {
        post signup_path, params: {
          user: {
            name: "",
            email: "user@invalid",
            password: "foo",
            password_confirmation: "bar"
          }
        }
      }.not_to change(User, :count)
    end

    it "有効な値を渡した場合、ユーザの数が増えること" do
      get signup_path
      expect {
        post signup_path, params: {
          user: {
            name: "Example User",
            email: "user@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.to change(User, :count).by(1)
      expect(is_logged_in?).to be_truthy
    end
  end
end
