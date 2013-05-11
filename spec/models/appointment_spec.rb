require 'spec_helper'

describe Appointment do
  let(:user) { create(:user) }
  let(:appt) { Appointment.create(user_id: user.id,
                                  name: "Dentist",
                                  date: "03/05/2013",
                                  start_time: "11:15 AM",
                                  end_time: "2:00 PM") }
  subject { appt }

  it { should respond_to :start_time }
  it { should respond_to :end_time }
  it { should be_valid }
  its(:start_min) { should eql(Event.time_to_min("11:15 AM")) }
  its(:end_min) { should eql(Event.time_to_min("2:00 PM")) }
  it { should be_saveable }

  describe "when name is not present" do
    before { appt.name = ""}
    it { should_not be_valid }
  end

  describe "when start time is not present" do
    let(:other_appt) { Appointment.create(user_id: user.id,
                                          name: "Doctor",
                                          date: "03/05/2013",
                                          end_time: "2:00 PM") }

    subject { other_appt }
    it { should_not be_valid }
  end

  describe "when end time is not present" do
    let(:other_appt) { Appointment.create(user_id: user.id,
                                          name: "Doctor",
                                          date: "03/05/2013",
                                          start_time: "2:00 PM") }

    subject { other_appt }
    it { should_not be_valid }
  end

  describe "changing the time" do
    before do
      appt.start_time = "1:00 AM"
      appt.save!
    end
    its(:start_min) { should eql(Event.time_to_min("1:00 AM")) }
  end

  it "can be represented as a hash for the SchedLogic API" do
    appt1 = create(:appointment,
                   start_time: '8:35 AM',
                   end_time: '10:06 AM')
    expect(appt1.to_schedlogic).to eql({ start: (4 * 4 + 2),
                                         end: (6 * 4 + 1) })

    appt2 = create(:appointment,
                   start_time: '4:00 AM',
                   end_time: '8:00 AM')
    expect(appt2.to_schedlogic).to eql({ start: 0,
                                         end: 4 * 4 })

    appt3 = create(:appointment,
                   start_time: '2:00 AM',
                   end_time: '4:00 AM')
    expect(appt3.to_schedlogic).to eql({ start: 22 * 4,
                                         end: 24 * 4 })
  end

  it "unschedules overlapping tasks for the day when updated" do
    overlapping_task = create(:task,
                              user: user,
                              date: appt.date,
                              earliest: '1:30 PM',
                              latest: '2:30 PM',
                              length: 30,
                              time_units: 'minutes',
                              start_time: '2:00 PM',
                              end_time: '2:30 PM')
    ok_task = create(:task,
                     user: user,
                     date: appt.date.to_date + 2.days,
                     earliest: '2:00 PM',
                     latest: '4:00 PM',
                     start_time: '2:30 PM',
                     end_time: '3:00 PM',
                     length: 30,
                     time_units: 'minutes')

    appt.start_time = '2:00 PM'
    appt.end_time = '2:30 PM'
    appt.save!

    overlapping_task = Task.find(overlapping_task.id)
    overlapping_task.start_time.should be_nil
    overlapping_task.end_time.should be_nil

    ok_task = Task.find(ok_task.id)
    ok_task.start_time.should eql '2:30 PM'
    ok_task.end_time.should eql '3:00 PM'
  end
end
