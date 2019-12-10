require 'rails_helper'

RSpec.describe "Logins", type: :system do

  let(:user) { create(:user) }
 describe "Login" do
  context "無効な情報を与えた時" do
    it "ログインに失敗すること" do
      visit login_path
      expect(page).to have_selector '.login-container'
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      find(".form-submit").click
      expect(current_path).to eq login_path
      expect(page).to have_selector '.login-container'
      expect(page).to have_selector '.alert-danger'
    end

    it "ページを移動した際、フラッシュが消えること" do
      visit login_path
      expect(page).to have_selector '.login-container'
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      find(".form-submit").click
      expect(current_path).to eq login_path
      expect(page).to have_selector '.login-container'
      expect(page).to have_selector '.alert-danger'
      #ページを切り替えた時、フラッシュが消えているか確認
      visit root_path
      expect(page).not_to have_selector '.alert-danger'
    end
  end

  context "正しい情報を与えた時" do
    it "ログインに成功するか" do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'password'
      find(".form-submit").click
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector '.show-container'
      expect(page).to have_selector '.btn-logout-extend'
      expect(page).not_to have_selector '.btn-login-extend'
    end
  end
end 

 describe "Logout" do
    it "contains login button without logout button" do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'password'
      find(".form-submit").click
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector '.show-container'
      expect(page).to have_selector '.btn-logout-extend'
      expect(page).not_to have_selector '.btn-login-extend'
      click_on 'ログアウト'
      expect(current_path).to eq root_path
      expect(page).to have_selector '.home-container'
      expect(page).to have_selector '.btn-login-extend'
      expect(page).not_to have_selector '.btn-logout-extend'
    end
  end
end
