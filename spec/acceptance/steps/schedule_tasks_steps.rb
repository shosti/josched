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
        earliest: earliest,
        latest: latest,
        length: units.match(/hours?/) ? length.to_i * 60 : length.to_i }
    end
  end
end
