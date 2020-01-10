require 'rails_helper'

RSpec.describe Micropost, type: :model do

  let(:user) { create(:user) }
  let(:micropost) { user.microposts.build(memo: "あいうえお", user_id: user.id) }

  describe "Micropost" do
    it "が有効になること" do
      expect(micropost).to be_valid
    end

    it "が無効になること" do
      micropost.update_attributes(memo: "  ", picture: nil, user_id: user.id)
      expect(micropost).to be_invalid
    end

    it "最新の投稿が一番最初に来ること" do
      create(:memos, :memo_1, user_id: user.id, created_at: 10.minutes.ago)
      create(:memos, :memo_2, user_id: user.id, created_at: 3.years.ago)
      create(:memos, :memo_3, user_id: user.id, created_at: 2.hours.ago)
      memo_4 = create(:memos, :memo_4, user_id: user.id, created_at: Time.zone.now)
      expect(Micropost.first).to eq memo_4
    end
  end

  describe "user_id" do
    it "が空の場合無効になること" do
      micropost.user_id = nil
      expect(micropost).to be_invalid
    end
  end

  describe "memo" do
    it "255文字が最大であること" do
      micropost.memo = "a" * 255
      expect(micropost).to be_valid
      micropost.memo = "a" * 256
      expect(micropost).to be_invalid
    end
  end
end
