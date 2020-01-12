# require 'rails_helper'
#
# RSpec.describe "Users", type: :request do
#
#   let(:user) { create(:user) }
#
#   describe "GET /users/:id" do
#     it "非ログイン時にuserページにアクセスしようとすると、ログインを促される" do
#       get user_path(user)
#       follow_redirect!
#       expect(request.fullpath).to eq '/login'
#     end
#   end
# end
