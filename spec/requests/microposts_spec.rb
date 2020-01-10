require 'rails_helper'

RSpec.describe "Microposts", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  def post_valid_information
    post microposts_path, params: { micropost: { memo: "aaa" } }
  end

  def post_invalid_information
    post microposts_path, params: { micropost: { memo: nil } }
  end

  def patch_valid_information
    patch micropost_path, params: { micropost: { memo: "bbb" } }
  end

  def patch_invalid_information
    patch micropost_path, params: { micropost: { memo: nil } }
  end

  describe "POST /microposts" do
    it "ログインしていない時投稿できないこと" do
      expect{ post_valid_information }.not_to change(Micropost, :count)
      follow_redirect!
      expect(request.fullpath).to eq '/login'
    end
   context "内容が空の時"
    it "投稿に失敗すること" do
      log_in_as(user)
      get root_path
      expect{ post_invalid_information }.not_to change(Micropost, :count)
    end
   context "正しい情報を入力した時"
    it "投稿に成功すること" do
      log_in_as(user)
      get root_path
      expect(request.fullpath).to eq '/'
      expect{ post_valid_information }.to change(Micropost, :count).by(1)
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end
  end

  describe "DELETE /micropost" do
   context "ログインしていない時"
    it "投稿が削除できないこと" do
      delete micropost_path(1)
      follow_redirect!
      expect(request.fullpath).to eq '/login'
    end
   context "別のユーザとしてログインしている時"
    it "投稿を削除できないこと" do
      log_in_as(user)
      get user_path(user)
      post_valid_information
      follow_redirect!
      delete logout_path
      log_in_as(other_user)
      get user_path(other_user)
      expect(request.fullpath).to eq '/users/2'
      post_valid_information
      expect{ delete micropost_path(1) }.not_to change(Micropost, :count)
      expect{ delete micropost_path(2) }.to change(Micropost, :count).by(-1)
    end
   context "正しいユーザとしてログインした時"
    it "投稿の削除に成功すること" do
      log_in_as(user)
      get user_path(user)
      expect{ post_valid_information }.to change(Micropost, :count).by(1)
      follow_redirect!
      expect{ delete micropost_path(1) }.to change(Micropost, :count).by(-1)
      follow_redirect!
      expect(request.fullpath).to eq '/users/1'
      expect(flash[:success]).to be_truthy
    end
  end

  describe "GET /microposts/:id/edit" do
   context "ログインしていない時"
    it "投稿の編集に失敗すること" do
      log_in_as(user)
      post_valid_information
      follow_redirect!
      delete logout_path
      follow_redirect!
      get edit_micropost_path(1)
      follow_redirect!
      expect(request.fullpath).to eq '/login'
    end
   context "別のユーザとしてログインした時"
    it "投稿に失敗すること" do
      log_in_as(user)
      post_valid_information
      follow_redirect!
      delete logout_path
      follow_redirect!
      log_in_as(other_user)
      get edit_micropost_path(1)
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end

    it "内容を空にして、編集をした時、失敗すること" do
      log_in_as(user)
      get user_path(user)
      post_valid_information
      follow_redirect!
      get edit_micropost_path(1)
      expect(request.fullpath).to eq '/microposts/1/edit'
      patch_invalid_information
      expect(request.fullpath).to eq '/microposts/1'
    end

    it "投稿の編集に成功すること" do
      log_in_as(user)
      get user_path(user)
      post_valid_information
      follow_redirect!
      get edit_micropost_path(1)
      expect(request.fullpath).to eq '/microposts/1/edit'
      patch_valid_information
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end
  end
end
