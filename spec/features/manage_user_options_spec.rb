require 'spec_helper'

feature "Managing user options" do
  let(:user) { create(:user) }

  before do
    visit day_path('today', as: user)
    click_link 'edit-user'
  end

  describe "change password" do
    before do
      fill_in 'New password', with: 'booglie'
      click_button 'Change password'
    end

    scenario "after password change" do
      page.should have_text user.email
      page.should have_text 'Password changed'
    end

    scenario "re-signing in" do
      click_link 'Sign out'
      click_link 'Sign in'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'booglie'
      click_button 'Sign in'

      page.should have_text user.email
    end
  end

  scenario "deleting account" do
    user_id = user.id
    click_button 'Delete account'

    page.should_not have_text user.email
    page.should have_text 'Sign in'
    User.find_all_by_id(user_id).should be_empty
  end
end
