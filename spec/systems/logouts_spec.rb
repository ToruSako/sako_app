require 'rails_helper'

RSpec.describe "Logins", type: :system do

  let(:user) { create(:user) }

  describe "Logout" do
      it "ログアウトした時、レイアウトが正しく表示されていること" do
         visit login_path
         fill_in 'メールアドレス', with: user.email
         fill_in 'パスワード', with: 'password'
         find(".form-submit").click
         expect(current_path).to eq user_path(1)
         expect(page).to have_selector '.show-container'
         expect(page).to have_selector '.btn-logout-extend'
         click_on 'ログアウト'
         expect(current_path).to eq root_path
         expect(page).to have_selector '.home-container'
         expect(page).to have_selector '.btn-login-extend'
         expect(page).not_to have_selector '.btn-logout-extend'
     end
  end
end
