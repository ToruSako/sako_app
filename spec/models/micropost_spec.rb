require 'rails_helper'

RSpec.describe Micropost, type: :model do

  let(:user) { create(:user) }
  let(:micropost) { user.microposts.build(memo: "Lorem ipsum", user_id: user.id) }

  describe "Micropost" do
    it "should be valid" do
      expect(micropost).to be_valid
    end

    it "should not be valid" do
      micropost.update_attributes(memo: "  ", picture: nil, user_id: user.id)
      expect(micropost).to be_invalid
    end

    it "should be most recent first" do
      create(:memos, :memo_1, created_at: 10.minutes.ago)
      create(:memos, :memo_2, created_at: 3.years.ago)
      create(:memos, :memo_3, created_at: 2.hours.ago)
      memo_4 = create(:memos, :memo_4, created_at: Time.zone.now)
      expect(Micropost.first).to eq memo_4
    end
  end

  describe "user_id" do
    it "should not be present" do
      micropost.user_id = nil
      expect(micropost).to be_invalid
    end
  end

  describe "memo" do
    it "should not be at most 255 characters" do
      micropost.memo = "a" * 255
      expect(micropost).to be_valid
      micropost.memo = "a" * 256
      expect(micropost).to be_invalid
    end
  end
end
