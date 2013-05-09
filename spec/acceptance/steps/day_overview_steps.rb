module EventSteps
  step "I work from home" do
    @user = create(:user)
  end

  def times(time_str)
    time_re = /[0-9:]+ [AP]M/

    if time_str.match(/Until/)
      ['4:00 AM', time_str.match(time_re)[0]]
    elsif time_str.match(/After/)
      [time_str.match(time_re)[0], '4:00 AM']
    else
      time_str.split(/-/)
    end
  end

  step "my day looks like this:" do |appts_table|
    @appts = appts_table.hashes.map do |appt|
      name = appt['Task']
      start_time, end_time = times(appt['Time'])

      visit new_user_appointment_path(@user, as: @user)
      fill_in 'Name', with: name
      fill_in 'Date', with: Date.today.to_s
      fill_in 'Start time', with: start_time
      fill_in 'End time', with: end_time
      click_button 'Schedule'

      { name: name,
        start_time: start_time,
        end_time: end_time }
    end
  end

  step "I go to today's overview page" do
    visit day_path('today', as: @user)
  end

  step "I should see all of my appointments" do
    @appts.each do |appt|
      page.should have_text appt[:name]
      page.should have_text "#{appt[:start_time]}-#{appt[:end_time]}"
    end
  end

  step "I should see the following free times:" do |times_table|
    times_table.hashes.each do |time_h|
      t = time_h['Time']
      page.should have_text "Free #{t}"
    end
  end
end
