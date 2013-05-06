module ApplicationHelper
  def format_date(date)
    date.strftime('%m/%d/%Y')
  end

  def format_time(time)
    time.strftime('%I:%M %p')
  end
end
