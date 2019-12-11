require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do


   let(:user) { create(:user) }

   describe "#current_user" do
     it "リメンバーダイジェストが有効な値の場合、正しい処理を行うこと" do
       remember(user)
       expect(current_user).to eq user
       expect(is_logged_in?).to be_truthy
     end

     it "リメンバーダイジェストが無効な値の場合、current_userはnilを返すこと" do
       remember(user)
       user.update_attribute(:remember_digest, User.digest(User.new_token))
       expect(current_user).to be_nil
     end
   end
 end
