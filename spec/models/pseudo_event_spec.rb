require 'spec_helper'

describe PseudoEvent do
  let(:event) { build(:pseudo_event) }

  subject { event }

  it { should_not be_saveable }
  it 'should not be saveable' do
    event.save
    event.save!
    PseudoEvent.create

    PseudoEvent.select { true }.count.should eql 0
  end

  it 'can be a free time' do
    free_time = PseudoEvent.free_time(Event.time_to_min('8:00 AM'),
                                      Event.time_to_min('9:30 PM'))
    free_time.name.should eql 'Free'
    free_time.start_time.should eql '8:00 AM'
    free_time.end_time.should eql '9:30 PM'
  end

  it 'can be a sleep' do
    sleep_until = PseudoEvent.sleep_until(Event.time_to_min('8:00 AM'))
    sleep_after = PseudoEvent.sleep_after(Event.time_to_min('11:00 PM'))

    sleep_until.name.should eql 'Sleep'
    sleep_until.start_time.should eql '4:00 AM'
    sleep_until.end_time.should eql '8:00 AM'
    sleep_after.start_time.should eql '11:00 PM'
    sleep_after.end_time.should eql '4:00 AM'
  end
end
