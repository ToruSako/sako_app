require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { User.new(
    name: "Example User",
    email: "user@example.com",
    password: "foobar",
    password_confirmation: "foobar"
  ) }

  describe "User" do
    it "が有効になること" do
      expect(user).to be_valid
    end
  end

  describe "name" do
    it "が空だと無効になること" do
      user.name = "  "
      expect(user).to be_invalid
    end

    context "50 文字" do
      it "は有効なこと" do
        user.name = "a" * 50
        expect(user).to be_valid
      end
    end

    context "51 文字" do
      it "は長すぎること" do
        user.name = "a" * 51
        expect(user).to be_invalid
      end
    end
  end

  describe "email" do
    it "が空だと無効になること" do
      user.email = "  "
      expect(user).to be_invalid
    end

    context "254 characters" do
      it "は有効になること" do
        user.email = "a" * 243 + "@example.com"
        expect(user).to be_valid
      end
    end

    context "255 characters" do
      it "は長すぎること" do
        user.email = "a" * 244 + "@example.com"
        expect(user).to be_invalid
      end
    end

    it "有効なメールアドレスを受け取ること" do
      user.email = "user@example.com"
      expect(user).to be_valid

      user.email = "USER@foo.COM"
      expect(user).to be_valid

      user.email = "A_US-ER@foo.bar.org"
      expect(user).to be_valid

      user.email = "first.last@foo.jp"
      expect(user).to be_valid

      user.email = "alice+bob@baz.cn"
      expect(user).to be_valid
    end

    it "無効なメールアドレスを拒否すること" do
      user.email = "user@example,com"
      expect(user).to be_invalid

      user.email = "user_at_foo.org"
      expect(user).to be_invalid

      user.email = "user.name@example."
      expect(user).to be_invalid

      user.email = "foo@bar_baz.com"
      expect(user).to be_invalid

      user.email = "foo@bar+baz.com"
      expect(user).to be_invalid

      user.email = "foo@bar..com"
      expect(user).to be_invalid
    end

    it "一意性をもつこと" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save!
      expect(duplicate_user).to be_invalid
    end

    it "小文字で登録されること" do
      user.email = "Foo@ExAMPle.CoM"
      user.save!
      expect(user.reload.email).to eq 'foo@example.com'
    end
  end

  describe "password and password_confirmation" do
    it "空だと無効になること" do
      user.password = user.password_confirmation = " " * 6
      expect(user).to be_invalid
    end

    context "5 文字の時" do
      it "短すぎること" do
        user.password = user.password_confirmation = "a" * 5
        expect(user).to be_invalid
      end
    end

    context "6 文字の時" do
      it "有効なこと" do
        user.password = user.password_confirmation = "a" * 6
        expect(user).to be_valid
      end
    end
  end

    describe "ユーザーモデルメソッドのテスト" do
      describe "authenticated?" do
        it "remember_digestがnilなら即座に認証を終了させること" do
          expect(user.authenticated?(:remember,'')).to be_falsey
        end
      end
    end
end
