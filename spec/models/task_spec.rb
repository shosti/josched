require 'spec_helper'

describe Task do
  describe 'basic properties' do
    let(:task) { create(:task) }

    subject { task }
    it { should be_saveable }
  end

  describe 'storing times as quarter-hours since 4 AM, rounded inward' do
    it 'stores 4-8 AM as 0-16' do
      t = create(:task, earliest: '4:00 AM', latest: '8:00 AM')
      expect(t.earliest_quart).to eql 0
      expect(t.latest_quart).to eql (4 * 4)
    end

    it 'stores 12:01-1:59 as 33-39' do
      t = create(:task, earliest: '12:01 PM', latest: '1:59 PM')
      expect(t.earliest_quart).to eql (8 * 4 + 1)
      expect(t.latest_quart).to eql (9 * 4 + 3)
      expect(Task.find(t.id).earliest).to eql '12:15 PM'
      expect(Task.find(t.id).latest).to eql '1:45 PM'
    end

    it 'stores 4 AM-4AM as 0-96' do
      t = create(:task, earliest: '4:00 AM', latest: '4:00 AM')
      expect(t.earliest_quart).to eql 0
      expect(t.latest_quart).to eql 24 * 4
    end
  end

  describe 'validating times' do
    it 'cannot have times that overlap 4:00 AM' do
      t = build(:task, earliest: '3:00 AM', latest: '5:00 AM')
      t.should_not be_valid
    end

    it 'cannot hold times greater than 96' do
      t = build(
        :task,
        earliest: nil,
        latest: nil,
        earliest_quart: 24 * 4,
        latest_quart: 24 * 4 + 1)
      t.should_not be_valid
    end
  end

  describe 'storing length as quarter-hours, rounded up' do
    it 'stores 30 minutes as 2 quarts' do
      t = create(:task, length: 30, time_units: 'minutes')
      expect(t.length_quart).to eql 2
    end

    it 'stores 82 minutes as 6 quarts' do
      t = create(:task, length: 82, time_units: 'minutes')
      expect(t.length_quart).to eql 6
    end

    it 'stores 2 hours as 8 quarts' do
      t = create(:task, length: 2, time_units: 'hours')
      expect(t.length_quart).to eql 2 * 4
    end

    it 'stores 1.5 hours as 6 quarts' do
      t = create(:task, length: 1.5, time_units: 'hours')
      expect(t.length_quart).to eql 6
    end

    it 'stores 1.6 hours as 7 quarts' do
      t = create(:task, length: 1.6, time_units: 'hours')
      expect(t.length_quart).to eql 7
    end
  end

  describe 'nicely displaying time' do
    it 'displays 1.5 hours as 1.5 hours' do
      t = create(:task, length: 1.5, time_units: 'hours')
      t = Task.find(t.id)
      expect([t.length, t.time_units]).to eql [1.5, 'hours']
    end

    it 'displays 0.25 hours as 15 minutes' do
      t = create(:task, length: 0.25, time_units: 'hours')
      t = Task.find(t.id)
      expect([t.length, t.time_units]).to eql [15, 'minutes']
    end

    it 'displays 83 minutes as 1.5 hours' do
      t = create(:task, length: 83, time_units: 'minutes')
      t = Task.find(t.id)
      expect([t.length, t.time_units]).to eql [1.5, 'hours']
    end
  end

  describe 'interacting with SchedLogic' do
    let(:task) do
      create(
        :task,
        length: 1.5,
        time_units: 'hours',
        earliest: '8:00 AM',
        latest: '12:00 PM')
    end

    it 'can be represented as a hash for the SchedLogic API' do
      expect(task.to_schedlogic).to eql(
        { earliest: 4 * 4,
          latest: 4 * 8,
          length: 6,
          id: task.id })
    end

    it 'can be concretely scheduled' do
      task.schedule(4 * 4, 4 * 4 + 6)
      task.should be_valid
      expect(task.start_time).to eql '8:00 AM'
      expect(task.end_time).to eql '9:30 AM'
    end

    it 'can be scheduled from SchedLogic data' do
      Task.schedule_task(
        { 'id' => task.id,
          'start' => 4 * 4,
          'end' => 4 * 4 + 6 })
      t = Task.find(task.id)
      t.should be_valid
      expect(t.start_time).to eql '8:00 AM'
      expect(t.end_time).to eql '9:30 AM'
    end

    describe 'when editing' do
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
