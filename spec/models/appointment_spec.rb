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
end
