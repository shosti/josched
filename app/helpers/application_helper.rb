module ApplicationHelper
  def format_date(date)
    if date
      date.strftime('%m/%d/%Y')
    end
  end

  def format_rfc_time(time)
    if time
      time = Time.parse(time) if time.is_a? String
      time.strftime('%H:%M:%S')
    end
  end
end
