require 'spec_helper'

describe Day do
  let(:user) { create(:user) }

  it "parses dates" do
    expect(Day.parse_date('today')).to eql(Date.today)
    expect(Day.parse_date(nil)).to eql(Date.today)
    expect(Day.parse_date('')).to eql(Date.today)
    expect(Day.parse_date(3.weeks.ago)).to eql(3.weeks.ago.to_date)
    expect(Day.parse_date('1988-03-30')).to eql(Date.parse('30 March 1988'))
  end

  describe "getting events for a day" do
    before do
      5.times do
        create(:appointment, date: 3.weeks.ago, user: user)
      end
      3.times do
        create(:appointment, date: 1.week.ago, user: user)
      end
      2.times do
        create(:appointment, date: Date.parse('03-12-2013'), user: user)
      end
      4.times do
        create(:appointment, date: Date.today, user: user)
      end
    end

    specify do
      expect(Day.find(3.weeks.ago, user).count).to eql(5)
      expect(Day.find(1.week.ago, user).count).to eql(3)
      expect(Day.find('03-12-2013', user).count).to eql(2)
      expect(Day.find('today', user).count).to eql(4)
      expect { Day.find('notthere', user) }.to raise_error ActiveRecord::RecordNotFound
    end
  end

end
