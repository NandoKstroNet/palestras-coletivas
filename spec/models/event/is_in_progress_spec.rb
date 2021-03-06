require 'spec_helper'

describe Event, ".is_in_progress?", :type => :model do
  let(:user) { create(:user, :paul) }
  context "when the event has not yet started" do
    let(:event) { create(:event, :tasafoconf, owner: user, start_date: Date.today + 2, end_date: Date.today + 2) }

    it "returns false" do
      expect(event.is_in_progress?).to be false
    end
  end

  context "when the event is in progress" do
    let(:event) { create(:event, :tasafoconf, owner: user, start_date: Date.today, end_date: Date.today) }

    it "returns true" do
      expect(event.is_in_progress?).to be true
    end
  end

  context "when the event has ended" do
    let(:event) { create(:event, :tasafoconf, owner: user, start_date: Date.today - 2, end_date: Date.today - 2) }

    it "returns false" do
      expect(event.is_in_progress?).to be false
    end
  end
end