require 'spec_helper'

feature "Manage appointments" do
  include ApplicationHelper

  let(:user) { create(:user) }
  let(:appt) { create(:appointment,
                      name: "Doctor",
                      start_time: "3:45 PM",
                      end_time: "5:45 PM",
                      user: user) }

  describe "schedule new appointment" do
    before { visit new_user_appointment_path(user, as: user) }

    scenario "with valid information" do
      fill_in 'Name', with: "Dentist"
      fill_in 'Location', with: "1482 9th Ave, SF"
      fill_in 'Date', with: "05/05/2013"
      fill_in 'Start time', with: "2:00 PM"
      fill_in 'End time', with: "3:30 PM"
      click_button 'Schedule'

      expect(page).to have_text "Appointment scheduled"
      expect(page).to have_text "Dentist"
      expect(page).to have_text "2:00 PM-3:30 PM"
      expect(page).to have_text "05/05/2013"
    end

    scenario "with invalid information" do
      fill_in 'Name', with: "Dentist"
      click_button 'Schedule'

      expect(page).to have_text "Date can't be blank"
    end
  end

  scenario "edit appointment" do
    visit edit_user_appointment_path(user, appt, as: user)
    fill_in 'Name', with: "Psycotherapist"
    click_button 'Save changes'

    expect(page).to have_text "Appointment updated"
    expect(page).to have_text "Psycotherapist"
    expect(page).not_to have_text "Doctor"
  end

  scenario "show appointment details" do
    visit user_appointment_path(user, appt, as: user)

    expect(page).to have_text "Doctor"
    expect(page).to have_text "3:45 PM-5:45 PM"
  end

  describe "listing" do
    let!(:appt1) { create(:appointment, user: user, date: Date.today) }
    let!(:appt2) { create(:appointment, user: user, date: Date.today) }
    let!(:appt3) { create(:appointment, user: user, date: 1.day.ago.to_date) }

    scenario "all appointments" do
      visit user_appointments_path(user, as: user)
      page.should have_text appt1.name
      page.should have_text appt2.name
      page.should have_text appt3.name
    end

    scenario "appointments for a specific day" do
      visit user_appointments_path(user, date: 'today', as: user)
      page.should have_text format_date(Date.today)
      page.should have_text appt1.name
      page.should have_text appt2.name
      page.should_not have_text appt3.name
    end
  end

  scenario "delete appointment" do
    visit edit_user_appointment_path(user, appt, as: user)
    click_button 'Delete appointment'

    expect(page).to have_text "Appointment deleted"
    expect(page).not_to have_text "Doctor"
  end

  describe "without authorization" do
    scenario "new appointment" do
      visit new_user_appointment_path(user)
      expect(current_path).to eql(sign_in_path)
    end

    scenario "edit appointment" do
      visit edit_user_appointment_path(user, appt)
      expect(current_path).to eql(sign_in_path)
    end
  end

  describe "as the wrong user" do
    let(:other_user) { create(:user) }

    scenario "new appointment" do
      visit new_user_appointment_path(user, as: other_user)
      expect(current_path).to eql(day_path('today'))
    end

    scenario "edit appointment" do
      visit edit_user_appointment_path(user, appt, as: other_user)
      expect(current_path).to eql(day_path('today'))
    end
  end
end
