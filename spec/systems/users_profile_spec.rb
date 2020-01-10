require 'rails_helper'

RSpec.describe "Logins", type: :system do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user)}

  describe "users_show layout" do
    it "自分のユーザーのプロフィールページが正しく表示されていること" do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'password'
      find(".form-submit").click
      find(".btn-profile").click
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector '.user-name'
      expect(page).to have_selector '.col-logs'
      find(".btn-logout-extend").click
      visit user_path(1)
      expect(page).not_to have_link 'プロフィール編集'
    end
  end
end
