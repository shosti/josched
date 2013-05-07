require 'spec_helper'

describe "routing to day pages" do
  it 'routes /day/:date to events#index for date' do
    expect(get: '/day/today').to route_to(controller: 'events',
                                          action: 'index',
                                          date: 'today')
    expect(get: '/day/2013-05-08').to route_to(controller: 'events',
                                               action: 'index',
                                               date: '2013-05-08')
  end

  it "routes /day to today's date" do
    expect(get: '/day').to route_to(controller: 'events',
                                    action: 'index',
                                    date: 'today')
  end
end
