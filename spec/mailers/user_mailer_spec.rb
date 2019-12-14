require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  let(:user) { create(:user) }

  describe "account_activation" do
    it "renders mails" do
      user.activation_token = User.new_token
      mail = UserMailer.account_activation(user)
      expect(mail.subject).to eq("マッスあっぷへようこそ。下記のリンクをクリックして、本登録を完了させてください。")
      expect(mail.to).to eq(["michael@example.com"])
      expect(mail.from).to eq(["noreply@example.com"])
      expect(mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join).to include("Michael Example")
    end

    # it "renders the body" do
    #   expect(mail.body.encoded).to match("Hi")
    # end
  end

  # describe "password_reset" do
  #   let(:mail) { UserMailer.password_reset }
  #
  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Password reset")
  #     expect(mail.to).to eq(["to@example.org"])
  #     expect(mail.from).to eq(["from@example.com"])
  #   end
  #
  #   it "renders the body" do
  #     expect(mail.body.encoded).to match("Hi")
  #   end
  # end

end
