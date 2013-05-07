class Day
  def self.parse_date(date)
    if date.instance_of? Date
      date
    elsif date == 'today' || date.blank?
      Date.today
    elsif date.is_a? String
      Date.parse(date)
    else
      date.to_date
    end
  end

  def self.find(date, user)
    unless date.instance_of? Date
      begin
        date = Day.parse_date(date)
      rescue
        raise ActiveRecord::RecordNotFound
      end
    end

    user.events.find_all_by_date(date,
                                 order: 'start_min ASC')
  end
end
