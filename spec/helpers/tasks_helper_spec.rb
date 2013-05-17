require 'spec_helper'

describe TasksHelper do
  it 'formats task length' do
    t1 = create(:task, length: 15, time_units: 'minutes')
    task_length(t1).should eql '15 minutes'

    t2 = create(:task, length: 1, time_units: 'hours')
    task_length(t2).should eql '1 hour'

    t3 = create(:task, length: 1.5, time_units: 'hours')
    task_length(t3).should eql '1.5 hours'

    t4 = create(:task, length: 1.25, time_units: 'hours')
    task_length(t4).should eql '1.25 hours'
  end
end
