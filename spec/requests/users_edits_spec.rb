require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  def patch_invalid_information
    patch user_path(user), params: {
      user: {
      name: "",
      email: "foo@invalid",
      password: "foo",
      password_confirmation: "bar"
     }
   }
  end

  context "valid" do
    it "is valid edit information" do
      log_in_as(user)
      get edit_user_path(user)
      patch_valid_information
      expect(flash[:success]).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq '/users/1/edit'
    end
    it "正しい情報でログインした時、編集ページに戻る" do
      get edit_user_path(user)
      follow_redirect!
      expect(request.fullpath).to eq '/login'
      log_in_as(user)
      expect(request.fullpath).to eq '/users/1/edit'
    end
end

  describe "GET /users/:id/edit" do
    context "無効な時" do
      it "is invalid because of having not log in" do
        get edit_user_path(user)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end

      it "別のユーザでログインした時に、無効になること" do
        log_in_as(other_user)
        get edit_user_path(user)
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end

      it "無効な情報を入力した場合、showページにリダイレクトすること" do
       log_in_as(user)
       expect(is_logged_in?).to be_truthy
       get edit_user_path(user)
       expect(request.fullpath).to eq '/users/1/edit'
       patch_invalid_information
       expect(flash[:danger]).to be_truthy
       expect(request.fullpath).to eq '/users/1'
      end
      it "does not redirect update because of having log in as wrong user" do
　　　  log_in_as(other_user)
  　　　get edit_user_path(user)
  　　　patch_valid_information
  　　　follow_redirect!
　　　  expect(request.fullpath).to eq '/'
      end
    end
  end
end
