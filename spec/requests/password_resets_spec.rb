require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do

  let(:user) { create(:user) }

  describe "POST /password_resets" do

  it "正しい情報を入力した時、メールが送信されること" do
    get new_password_reset_path
    expect(request.fullpath).to eq '/password_resets/new'
    post password_resets_path, params: { password_reset: { email: user.email } }
    expect(flash[:info]).to be_truthy
    expect(flash[:danger]).to be_falsey
    follow_redirect!
    expect(request.fullpath).to eq '/'
  end
end

  describe "GET /password_resets/:id/edit" do
     context "メールアドレスが空の時"
      it "失敗すること" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = assigns(:user)
        get edit_password_reset_path(user.reset_token, email: "")
        expect(flash[:danger]).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/password_resets/new'
      end

     context "無効なユーザの場合"
      it "失敗すること" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = assigns(:user)
        user.toggle!(:activated)
        get edit_password_reset_path(user.reset_token, email: user.email)
        expect(flash[:danger]).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/password_resets/new'
        user.toggle!(:activated)
      end
     context "無効なトークンの時"
      it "失敗すること" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = assigns(:user)
        get edit_password_reset_path('wrong token', email: user.email)
        expect(flash[:danger]).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/password_resets/new'
      end
     context "正しい情報を受け取った時"
      it "成功すること" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = assigns(:user)
        get edit_password_reset_path(user.reset_token, email: user.email)
        expect(flash[:danger]).to be_falsey
        expect(request.fullpath).to eq "/password_resets/#{user.reset_token}/edit?email=#{CGI.escape(user.email)}"
      end
    end

    describe "PATCH /password_resets/:id" do
     context "無効なパスワードを受け取った時"
      it "失敗すること" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = assigns(:user)
        get edit_password_reset_path(user.reset_token, email: user.email)
        patch password_reset_path(user.reset_token), params: {
          email: user.email,
          user: {
            password: "foobaz",
            password_confirmation: "barquux"
          }
        }
        expect(request.fullpath).to eq "/password_resets/#{user.reset_token}"
      end
     context "空のパスワードを受け取った"
      it "失敗すること" do
      post password_resets_path, params: { password_reset: { email: user.email } }
        user = assigns(:user)
        get edit_password_reset_path(user.reset_token, email: user.email)
        patch password_reset_path(user.reset_token), params: {
          email: user.email,
          user: {
            password: "",
            password_confirmation: ""
          }
        }
        expect(request.fullpath).to eq "/password_resets/#{user.reset_token}"
      end
     context "期限ぎれのトークンを受け取った場合"
      it "失敗すること" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = assigns(:user)
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        get edit_password_reset_path(user.reset_token, email: user.email)
        patch password_reset_path(user.reset_token), params: {
          email: user.email,
          user: {
            password: "foobaz",
            password_confirmation: "foobaz"
          }
        }
        expect(flash[:danger]).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/password_resets/new'
      end
     context "正しい情報を受け取った時"
      it "成功すること" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = assigns(:user)
        get edit_password_reset_path(user.reset_token, email: user.email)
        patch password_reset_path(user.reset_token), params: {
          email: user.email,
          user: {
            password: "foobaz",
            password_confirmation: "foobaz"
          }
        }
        expect(flash[:success]).to be_truthy
        expect(is_logged_in?).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq "/users/1"
      end
    end
  end
