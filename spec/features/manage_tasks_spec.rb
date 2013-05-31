require 'spec_helper'

feature 'Manage tasks' do
  include ApplicationHelper

  let(:user) { create(:user) }
  let(:task) do
    create(
      :task,
      name: 'Practice',
      earliest: '1:00 PM',
      latest: '3:00 PM',
      length: '1',
      time_units: 'hours',
      user: user)
  end
  before do
    stub_request(:get, /#{SchedLogic::SCHEDLOGIC_URL}/).
      to_return(body: ActiveSupport::JSON.encode('none'))
  end

  describe 'schedule a task' do
    before { visit new_user_task_path(user, as: user) }

    scenario 'with valid information' do
      fill_in 'Name', with: 'Work'
      fill_in 'Date', with: Date.today.to_s
      fill_in 'Earliest', with: '2:00 PM'
      fill_in 'Latest', with: '4:00 PM'
      fill_in 'Length', with: '1'
      select 'hours', from: 'task_time_units'
      click_button 'Schedule'

      expect(page).to have_text 'Task scheduled'
    end

    scenario 'with invalid information' do
      fill_in 'Name', with: 'Work'
      fill_in 'Date', with: ''
      click_button 'Schedule'

      expect(page).to have_text "Date can't be blank"
      expect(page).to have_text "Earliest can't be blank"
      expect(page).to have_text "Latest can't be blank"
      expect(page).to have_text "Length can't be blank"
    end
  end

  scenario 'show task details' do
    visit user_task_path(user, task, as: user)

    expect(page).to have_text 'Practice'
    expect(page).to have_text format_date(task.date)
    expect(page).to have_text 'Timeframe: 1:00 PM-3:00 PM'
    expect(page).to have_text 'Length: 1 hour'
  end

  scenario 'edit task' do
    visit edit_user_task_path(user, task, as: user)
    fill_in 'Name', with: 'Paint'
    click_button 'Save changes'

    expect(page).to have_text 'Task updated'
  end

  scenario 'delete task' do
    visit edit_user_task_path(user, task, as: user)
    click_button 'Delete task'

    expect(page).to have_text 'Task deleted'
  end

  describe 'listing' do
    let!(:task1) { create(:task, user: user, date: Date.today) }
    let!(:task2) { create(:task, user: user, date: Date.today) }
    let!(:task3) { create(:task, user: user, date: Date.today - 1.day) }
    let!(:appt) { create(:appointment, user: user, date: Date.today) }

    scenario 'all appointments' do
      visit user_tasks_path(user, as: user)
      page.should have_text task1.name
      page.should have_text task2.name
      page.should have_text task3.name
      page.should_not have_text appt.name
    end

    scenario 'appointments for a specific day' do
      visit user_tasks_path(user, date: 'today', as: user)
      page.should have_text format_date(Date.today)
      page.should have_text task1.name
      page.should have_text task2.name
      page.should_not have_text task3.name
      page.should_not have_text appt.name
    end
  end
end
