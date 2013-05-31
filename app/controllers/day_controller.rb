require 'exceptions'

class DayController < ApplicationController
  before_filter :authorize

  def find
    redirect_to day_path(params[:date])
  end

  def show
    @date = Day.parse_date(params[:id])
    begin
      @events = Day.find(params[:id], current_user)
    rescue SchedLogic::ScheduleImpossibleException
      render 'impossible'
    rescue SchedLogic::ScheduleFailureException
      render 'failure'
    end
  end
end
