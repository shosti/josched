require 'spec_helper'

describe Event do
  it "can convert between time and minutes" do
    four_am = 4 * 60

    expect(Event.time_to_min('4:00 AM')).to eql(0)
    expect(Event.time_to_min('8:00 PM')).to eql((12 + 8) * 60 - four_am)
    expect(Event.time_to_min('12:00 PM')).to eql(12 * 60 - four_am)
    expect(Event.time_to_min('2:02 AM')).to eql((24 + 2) * 60 + 2 -
                                                four_am)
    expect(Event.min_to_time(0)).to eql('4:00 AM')
    expect(Event.min_to_time(22)).to eql('4:22 AM')
    expect(Event.min_to_time(4 * 60 + 5)).to eql('8:05 AM')
    expect(Event.min_to_time(13 * 60 + 30)).to eql('5:30 PM')
  end

  describe "should be findable by date" do
    before do
      5.times { create(:event, date: 3.weeks.ago) }
      2.times { create(:event, date: 3.weeks.ago.to_date) }
    end

    specify do
      expect(Event.find_all_by_date(3.weeks.ago.to_date).count).to eql(7)
    end
  end
end
