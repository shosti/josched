class EventsController < ApplicationController
  before_filter :authorize
  before_filter :correct_user

  private

  def correct_user
    redirect_to day_path('today') if
      current_user.id != params[:user_id].to_i
  end
end
