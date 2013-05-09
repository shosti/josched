require 'spec_helper'

describe Task do
  describe "basic properties" do
    let(:task) { create(:task) }

    subject { task }
    it { should be_saveable }
  end

  it "stores times as quarter-hours since 4 AM, rounded inward" do
    t1 = create(:task, earliest: '4:00 AM', latest: '8:00 AM')
    expect(t1.earliest_quart).to eql 0
    expect(t1.latest_quart).to eql (4 * 4)

    t2 = create(:task, earliest: '12:01 PM', latest: '1:59 PM')
    expect(t2.earliest_quart).to eql (8 * 4 + 1)
    expect(t2.latest_quart).to eql (9 * 4 + 3)
    expect(Task.find(t2.id).earliest).to eql '12:15 PM'
    expect(Task.find(t2.id).latest).to eql '1:45 PM'

    t3 = create(:task, earliest: '4:00 AM', latest: '4:00 AM')
    expect(t3.earliest_quart).to eql 0
    expect(t3.latest_quart).to eql 24 * 4
  end

  it "validates for invalid times" do
    t1 = build(:task, earliest: '3:00 AM', latest: '5:00 AM')
    t1.should_not be_valid

    t2 = build(:task,
               earliest: nil,
               latest: nil,
               earliest_quart: 24 * 4,
               latest_quart: 24 * 4 + 1)
    t2.should_not be_valid
  end

  it "stores length as quarter-hours, rounded up" do
    t1 = create(:task, length: 30, time_units: 'minutes')
    expect(t1.length_quart).to eql 2

    t2 = create(:task, length: 82, time_units: 'minutes')
    expect(t2.length_quart).to eql 6

    t3 = create(:task, length: 2, time_units: 'hours')
    expect(t3.length_quart).to eql 2 * 4

    t4 = create(:task, length: 1.5, time_units: 'hours')
    expect(t4.length_quart).to eql 6

    t5 = create(:task, length: 1.6, time_units: 'hours')
    expect(t5.length_quart).to eql 7
  end

  it "nicely reports time" do
    t1 = create(:task, length: 1.5, time_units: 'hours')
    t1 = Task.find(t1.id)
    expect([t1.length, t1.time_units]).to eql [1.5, 'hours']

    t2 = create(:task, length: 0.25, time_units: 'hours')
    t2 = Task.find(t2.id)
    expect([t2.length, t2.time_units]).to eql [15, 'minutes']

    t3 = create(:task, length: 83, time_units: 'minutes')
    t3 = Task.find(t3.id)
    expect([t3.length, t3.time_units]).to eql [1.5, 'hours']
  end

  describe "interacting with SchedLogic" do
    let(:task) do
      create(:task,
             length: 1.5,
             time_units: 'hours',
             earliest: '8:00 AM',
             latest: '12:00 PM')
    end

    it "can be represented as a hash for the SchedLogic API" do
      expect(task.to_schedlogic).to eql({ earliest: 4 * 4,
                                          latest: 4 * 8,
                                          length: 6,
                                          id: task.id })
    end

    it "can be concretely scheduled" do
      task.schedule(4 * 4, 4 * 4 + 6)
      task.should be_valid
      expect(task.start_time).to eql '8:00 AM'
      expect(task.end_time).to eql '9:30 AM'
    end

    it "can be scheduled from SchedLogic data" do
      Task.schedule_task({ 'id' => task.id,
                           'start' => 4 * 4,
                           'end' => 4 * 4 + 6 })
      t = Task.find(task.id)
      t.should be_valid
      expect(t.start_time).to eql '8:00 AM'
      expect(t.end_time).to eql '9:30 AM'
    end

    describe "when editing" do
      before { task.schedule(4 * 4, 4 * 4 + 6) }

      it "doesn't stay scheduled if length changes" do
        task.length_quart = 8
        task.save!

        expect(task.start_min).to be_nil
        expect(task.end_min).to be_nil
      end

      it "doesn't stay scheduled if earliest is no longer valid" do
        task.earliest_quart = 17
        task.save!

        expect(task.start_min).to be_nil
        expect(task.end_min).to be_nil
      end

      it "doesn't stay scheduled if latest is no longer valid" do
        task.latest_quart = 20
        task.save!

        expect(task.start_min).to be_nil
        expect(task.end_min).to be_nil
      end
    end
  end
end
