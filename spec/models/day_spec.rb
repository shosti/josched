require 'spec_helper'

describe Day do
  let(:user) { create(:user) }

  it "parses dates" do
    expect(Day.parse_date('today')).to eql Date.today
    expect(Day.parse_date(nil)).to eql Date.today
    expect(Day.parse_date('')).to eql Date.today
    expect(Day.parse_date(3.weeks.ago)).to eql 3.weeks.ago.to_date
    expect(Day.parse_date('1988-03-30')).to eql Date.parse('30 March 1988')
    expect(Day.parse_date(Date.today)).to eql Date.today
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
      expect(Day.find(3.weeks.ago, user).select do |e|
               e.type == 'Appointment'
             end.count).to eql 5

      expect(Day.find(1.week.ago, user).select do |e|
               e.type == 'Appointment'
             end.count).to eql 3

      expect(Day.find('03-12-2013', user).select do |e|
               e.type == 'Appointment'
             end.count).to eql 2

      expect(Day.find('today', user).select do |e|
               e.type == 'Appointment'
             end.count).to eql 4

      expect do
        Day.find('notthere', user)
      end.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "scheduling free time" do
    let(:date) { 1.day.ago.to_date }
    let(:user) { create(:user) }
    let(:appts) do
      [['4:00 AM', '8:00 AM'],
       ['10:00 AM', '11:01 AM'],
       ['12:00 PM', '12:30 PM'],
       ['12:30 PM', '4:00 PM'],
       ['7:00 PM', '3:59 AM']]
    end
    let(:free_times) do
      [['8:00 AM', '10:00 AM'],
       ['4:00 PM', '7:00 PM']]
    end

    before { schedule_appts appts }

    it "schedules in free time for times greater than 1 hour" do
      day = Day.find(date, user)
      day.count.should eql appts.count + free_times.count

      day[1].start_time.should eql free_times[0][0]
      day[1].end_time.should eql free_times[0][1]

      day[5].start_time.should eql free_times[1][0]
      day[5].end_time.should eql free_times[1][1]
    end
  end

  describe "merging and processing appointments for the SchedLogic API" do
    let(:date) { 3.days.ago.to_date }
    let(:appts) do
      [['9:35 AM', '10:46 AM'],
       ['11:01 AM', '11:30 AM'],
       ['3:15 PM', '3:35 PM']]
    end

    before { schedule_appts appts }

    specify do
      expect(Day.appts_to_schedlogic(Appointment.find_all_by_date(date))).
        to eql([{ start: 5 * 4 + 2,
                  end: 7 * 4 + 2 },
                { start: 11 * 4 + 1,
                  end: 11 * 4 + 3}])
    end
  end
end

def schedule_appts(appts)
  appts.each do |start_time, end_time|
    create(:appointment,
           date: date,
           user: user,
           start_time: start_time,
           end_time: end_time)
  end
end
