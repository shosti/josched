module ApplicationHelper
  def format_date(date)
    date.strftime('%m/%d/%Y') unless date.nil?
  end

  def format_time(time)
    time.strftime('%I:%M %p') unless time.nil?
  end

  def format_rfc_time(time)
    time.strftime('%H:%M:%S') unless time.nil?
  end
end
