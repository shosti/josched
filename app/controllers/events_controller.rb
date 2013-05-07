class EventsController < ApplicationController
  before_filter :authorize
  before_filter :correct_user, except: :index

  def show
    @event = current_user.events.find(params[:id])
  end

  def index
    @date = params[:date]

    if @date == 'today'
      @date = Date.today
    else
      begin
        @date = Date.parse(@date)
      rescue ArgumentError
        raise ActionController::RoutingError.new('Not Found')
      end
    end

    @events = current_user.day(@date)
  end

  private

  def correct_user
    redirect_to day_path('today') if current_user.id != params[:user_id].to_i
  end
end
