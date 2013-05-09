module ApplicationHelper
  def format_date(date)
    unless date.blank?
      date.strftime('%m/%d/%Y')
    end
  end

  def format_rfc_time(time)
    unless time.blank?
      time = Chronic.parse(time) if time.is_a? String
      time.strftime('%H:%M:%S')
    end
  end
end
