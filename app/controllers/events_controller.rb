class EventsController < ApplicationController
  before_filter :authorize
  before_filter :correct_user

  def show
    @event = current_user.events.find(params[:id])
  end

  private

  def correct_user
    redirect_to root_url if current_user.id != params[:user_id].to_i
  end
end
