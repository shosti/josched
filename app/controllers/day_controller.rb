class DayController < ApplicationController
  before_filter :authorize

  def show
    @events = Day.find(params[:id], current_user)
    @date = Day.parse_date(params[:id])
  end
end
