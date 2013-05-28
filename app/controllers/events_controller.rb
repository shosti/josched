class EventsController < ApplicationController
  before_filter :authorize
  before_filter :correct_user

  def edit
    @event = current_user.events.find(params[:id])
  end

  def show
    @event = current_user.events.find(params[:id])
  end

  def destroy
    event = current_user.events.find(params[:id])
    type = event.type
    event.destroy
    flash[:success] = "#{type} deleted"
    redirect_to day_path('today')
  end

  def index
    if params[:date]
      @date = Day.parse_date(params[:date])
      @events = current_user.events.
        where(type: @type, date: @date).
        order(:start_min)
    else
      @events = current_user.events.
        find_all_by_type(@type, order: 'date, start_min')
    end
  end

  private

  def correct_user
    if current_user.id != params[:user_id].to_i
      redirect_to day_path('today')
    end
  end
end
