require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#full_title" do
    context "page_title is empty" do
      it "removes symbol" do
        expect(helper.full_title).to eq('sako_app')
      end
    end

    context "page_title is not empty" do
      before do
        assign(:title, 'sako_app')
      end

      it "returns title and application name where contains symbol" do
        expect(helper.full_title).to eq('sako_app')
      end
    end
  end
end
