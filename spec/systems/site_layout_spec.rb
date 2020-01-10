require 'rails_helper'

RSpec.describe "SiteLayouts", type: :system do
  describe "home layout" do

    describe "about layout" do
        it "ページタイトルにAboutが含まれていること " do
          visit about_path
          expect(page).to have_link 'About'
        end
      end

    it "サインアップリンクが表示されていること" do
      visit root_path
      expect(page).to have_link 'はじめる', href: signup_path
    end

    it "ログインリンクが表示されていること" do
      visit root_path
      expect(page).to have_link 'ログイン', href: login_path
    end

  end
end
