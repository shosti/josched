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

  private

  def correct_user
    redirect_to day_path('today') if
      current_user.id != params[:user_id].to_i
  end
end
