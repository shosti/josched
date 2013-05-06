require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  describe "getting events for a day" do
    before do
      5.times do
        create(:appointment, date: 3.weeks.ago, user: user)
      end
      3.times do
        create(:appointment, date: 1.week.ago, user: user)
      end
      2.times do
        create(:appointment,
               date: Date.parse('03-12-2013'),
               user: user)
      end
      4.times do
        create(:appointment,
               date: Date.today,
               user: user)
      end
    end

    specify do
      expect(user.day(3.weeks.ago).count).to eql(5)
      expect(user.day(1.week.ago).count).to eql(3)
      expect(user.day(Date.parse('03-12-2013')).count).to eql(2)
      expect(user.day(Date.today).count).to eql(4)
    end
  end
end
