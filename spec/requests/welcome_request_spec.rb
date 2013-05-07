require 'spec_helper'

describe "visiting the welcome page" do
  let(:user) { create(:user) }

  it "should redirect to today's overview page for a logged-in user" do
    get root_path(as: user)
    expect(response).to redirect_to day_path('today')
  end
end
