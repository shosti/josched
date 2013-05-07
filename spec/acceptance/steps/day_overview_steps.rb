step "I work from home" do
  @user = create(:user)
end

step "my day looks like this:" do |appts_table|
  @appts = appts_table.hashes.map do |appt|
    time_str = appt['Time']
    time_re = /[0-9:]+ [AP]M/

    if time_str.match(/Until/)
      start_time = '4:00 AM'
      end_time = time_str.match(time_re)[0]
    elsif time_str.match(/After/)
      start_time = time_str.match(time_re)[0]
      end_time = '4:00 AM'
    else
      start_time, end_time = time_str.split(/-/)
    end

    create(:appointment,
           user: @user,
           name: appt['Task'],
           start_time: start_time,
           end_time: end_time,
           date: Date.today)
  end
end

step "I go to today's overview page" do
  visit day_path('today', as: @user)
end

step "I should see all of my tasks" do
  @appts.each do |appt|
    page.should have_text appt.name
    page.should have_text "#{appt.start_time}-#{appt.end_time}"
  end
end

step "I should see the following free times:" do |times_table|
  times_table.hashes.each do |time_h|
    t = time_h['Time']
    page.should have_text "Free #{t}"
  end
end
