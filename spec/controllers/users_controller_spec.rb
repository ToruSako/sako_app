require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "error message check" do
      it "値を空にするとフラッシュが出ること" do
          user = User.new()
          user.valid?
          expect(user.errors.messages[:name]).to include("を入力してください")
      end
    end
end
