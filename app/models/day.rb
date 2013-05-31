require 'schedlogic'

class Day
  MINIMUM_FREE_TIME_MINUTES = 60

  def self.parse_date(date)
    if date.instance_of? Date
      date
    elsif date.blank?
      Date.today
    elsif date.is_a? String
      date = Chronic.parse(date)
      date.to_date if date
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

  def self.schedule_day(tasks, appts, n)
    if tasks.any? { |t| t.start_min.blank? || t.end_min.blank? }
      tasks_data = SchedLogic.schedule(tasks, appts, n)
      begin
        tasks.zip(tasks_data).map do |task, task_data|
          task.schedule(task_data['start'], task_data['end'])
        end
      rescue
        raise SchedLogic::ScheduleFailureException
      end
    end

    (tasks + appts).sort_by(&:start_min)
  end

  def self.find(date, user)
    unless date.instance_of? Date
      date = Day.parse_date(date)
      raise ActiveRecord::RecordNotFound unless date
    end

    appts = user.appointments.find_all_by_date(
      date, order: 'start_min')
    tasks = user.tasks.find_all_by_date(
      date, order: 'earliest_quart, latest_quart')

    events = Day.schedule_day(tasks, appts, 0)
    Day.add_free_times(events)
  end
end
