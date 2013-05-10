require 'spec_helper'

describe User do
  describe "event associations" do
    let(:user) { create(:user) }
    before do
      5.times { create(:task, user: user) }
      3.times { create(:appointment, user: user) }
    end

    it "can access tasks, appointments, or both" do
      expect(user.tasks.count).to eql 5
      expect(user.appointments.count).to eql 3
      expect(user.events.count).to eql 8
    end

    it "should destroy associated events" do
      tasks = user.tasks.dup.to_a
      appts = user.appointments.dup.to_a

      user.destroy

      expect(tasks).not_to be_empty
      expect(appts).not_to be_empty

      tasks.each do |task|
        expect(Task.where(id: task.id)).to be_empty
      end

      appts.each do |appt|
        expect(Appointment.where(id: appt.id)).to be_empty
      end
    end
  end
end
