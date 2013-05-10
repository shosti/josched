require 'spec_helper'

feature "Site navigation" do
  let(:user) { create(:user) }
  let!(:today_appts) do
    (0...3).map do
      create(:appointment, user: user, date: Date.today)
    end
  end
  let!(:tomorrow_appts) do
    (0...5).map do
      create(:appointment, user: user, date: Date.today + 1.day)
    end
  end

  scenario "top navigation bar" do
    visit day_path(Date.today - 5.days, as: user)
    fill_in 'nav-date', with: Date.today
    click_button 'Go to day'
    should_see_today_appts

    fill_in 'nav-date', with: Date.today + 1.day
    click_button 'Go to day'
    should_see_tomorrow_appts
  end

  scenario "next and previous day" do
    visit day_path(Date.today, as: user)
    click_link 'Next day'
    should_see_tomorrow_appts

    click_link 'Previous day'
    should_see_today_appts
  end
end

def should_see_today_appts
  today_appts.each do |appt|
    page.should have_text appt.name
  end
  tomorrow_appts.each do |appt|
    page.should_not have_text appt.name
  end
end

def should_see_tomorrow_appts
  today_appts.each do |appt|
    page.should_not have_text appt.name
  end
  tomorrow_appts.each do |appt|
    page.should have_text appt.name
  end
end
