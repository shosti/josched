require 'spec_helper'

describe PseudoEvent do
  let(:event) { build(:pseudo_event) }

  subject { event }

  it { should_not be_saveable }
  it "should not be saveable" do
    event.save
    event.save!
    PseudoEvent.create

    PseudoEvent.select{ true }.count.should eql 0
  end

  it "can be a free time" do
    free_time = PseudoEvent.free_time(Event.time_to_min('8:00 AM'),
                                      Event.time_to_min('9:30 PM'))
    free_time.name.should eql 'Free'
    free_time.start_time.should eql '8:00 AM'
    free_time.end_time.should eql '9:30 PM'
  end
end
