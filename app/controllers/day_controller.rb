require 'exceptions'

class DayController < ApplicationController
  before_filter :authorize

  def show
    begin
      @events = Day.find(params[:id], current_user)
      @date = Day.parse_date(params[:id])
    rescue JoSched::ScheduleImpossibleException
      render 'impossible'
    rescue JoSched::ScheduleFailureException
      render 'failure'
    end
  end
end
