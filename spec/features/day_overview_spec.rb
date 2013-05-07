require 'spec_helper'

feature "Day overview" do
  let(:user) { create(:user) }

  scenario "for non-existent date" do
    -> do
      visit day_path('notthere', as: user)
    end.should raise_error(ActionController::RoutingError)
  end
end
