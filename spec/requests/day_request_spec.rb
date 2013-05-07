require 'spec_helper'

describe "Day page requests" do
  let(:user) { create(:user) }

  describe "the root page" do
    it "should redirect to today's overview page for a logged-in user" do
      get root_path(as: user)
      expect(response).to redirect_to day_path('today')
    end
  end

  it "should return 404 for non-existent dates" do
    -> do
      get day_path('notthere', as: user)
    end.should raise_error(ActionController::RoutingError)
  end
end
