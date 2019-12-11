require 'rails_helper'

RSpec.describe "SiteLayouts", type: :system do
  describe "home layout" do
    # it "contains root link" do
    #   visit root_path
    #   expect(page).to have_link nil, href: root_path, count: 2
    # end

    describe "about layout" do
        it "returns title with 'About | sako_app' " do
          visit about_path
          expect(page).to have_link 'About'
        end
      end

    it "contains signup link" do
      visit root_path
      expect(page).to have_link 'はじめる', href: signup_path
    end

    it "contains login link" do
      visit root_path
      expect(page).to have_link 'ログイン', href: login_path
    end

  end
end
