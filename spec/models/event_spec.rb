require 'spec_helper'

describe Event do
  describe "convert between time and minutes" do
    specify do
      today = Time.now.to_date

      expect(Event.time_to_min(today + 10.minutes)).to eql(10)
      expect(Event.time_to_min(today + 12.hours)).to eql(12 * 60)
      expect(Event.time_to_min(today + 2.hours + 2.minutes)).to eql(122)
      expect(Event.min_to_time(today, 22)).to eql(today + 22.minutes)
      expect(Event.min_to_time(today, 4 * 60 + 5)).to eql(today + 4.hours + 5.minutes)
    end
  end
end
