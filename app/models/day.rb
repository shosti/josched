class Day
  MINIMUM_FREE_TIME_MINUTES = 60

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

  def self.add_free_times(events)
    if events.count > 1
      events[1..-1].inject([events[0]]) do |events_so_far, this_event|
        end_of_last = events_so_far.last.end_min
        start_of_this = this_event.start_min
        if start_of_this - end_of_last >= MINIMUM_FREE_TIME_MINUTES
          free_time = PseudoEvent.free_time(end_of_last, start_of_this)
          events_so_far << free_time << this_event
        else
          events_so_far << this_event
        end
      end
    else
      events
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

    Day.add_free_times(user.
                       events.
                       find_all_by_date(date,
                                        order: 'start_min ASC').to_a)
  end
end
