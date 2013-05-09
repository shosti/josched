module EventSteps
  step "I schedule the following tasks:" do |tasks_table|

    @tasks = tasks_table.hashes.map do |task|
      name = task['Task']
      earliest, latest = times(task['Timeframe'])
      length, units = task['Length'].split

      visit new_user_task_path(@user, as: @user)
      fill_in 'Name', with: name
      fill_in 'Date', with: Date.today.to_s
      fill_in 'Earliest', with: earliest
      fill_in 'Latest', with: latest
      fill_in 'Length', with: length
      if units.match /hours?/
        select 'hours', from: 'task_time_units'
      end
      click_button 'Schedule'

      { name: name,
        id: Task.find_by_name(name).id,
        earliest: earliest,
        latest: latest,
        length: units.match(/hours?/) ? length.to_i * 60 : length.to_i }
    end

    response = [{ 'tasks' =>
                  [{'start' => 19, 'end' => 20, 'id' => @tasks[0][:id]},
                   {'start' => 17, 'end' => 19, 'id' => @tasks[1][:id]},
                   {'start' => 24, 'end' => 28, 'id' => @tasks[2][:id]},
                   {'start' => 32, 'end' => 36, 'id' => @tasks[3][:id]}]}]

    stub_request(:get, /#{Day::SCHEDLOGIC_URL}/).
      to_return(body: ActiveSupport::JSON.encode(response))
  end

  step "I should see all of my tasks scheduled correctly" do
    @tasks.each do |task|
      match = page.text.match(/#{task[:name]}\s+([:0-9APM ]+)-([:0-9APM ]+)/)
      expect(match).to_not be_nil

      start_time = match[1]
      end_time = match[2]
      length = ((Time.parse(end_time) - Time.parse(start_time)) / 60).to_i
      length.should eql task[:length]
    end
  end
end
