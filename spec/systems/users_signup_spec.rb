require 'rails_helper'

RSpec.describe "UsersSignups", type: :system do

  it "無効な名前を入力した場合、エラーメッセージが表示されること" do
    visit signup_path
    fill_in '名前', with: ''
    fill_in 'メールアドレス', with: 'user@invalid'
    fill_in 'パスワード', with: 'foo'
    fill_in 'パスワード（再入力）', with: 'bar'
    click_on '新規ユーザ作成'
    expect(current_path).to eq signup_path
    expect(page).to have_selector '#error_explanation'
    # expect(page).to have_selector '名前を入力してください'
  end

  it "正しい情報を入力した場合、有効になること" do
    visit signup_path
    fill_in '名前', with: 'Example User'
    fill_in 'メールアドレス', with: 'user@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（再入力）', with: 'password'
    click_on '新規ユーザ作成'
    # follow_redirect!
    #作成したユーザのページにリダイレクトするか
    expect(current_path).to eq user_path(1)
    expect(page).not_to have_selector '#error_explanation'
  end
end
