require 'net/http'
require 'exceptions'

class Day
  SCHEDLOGIC_URL = 'https://schedlogic.herokuapp.com/schedule'
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

  def self.merge_overlapping_appts(appts)
    appts[1..-1].inject([appts[0]]) do |appts_so_far, this_appt|
      last_appt = appts_so_far.pop
      if last_appt[:end] >= this_appt[:start]
        appts_so_far << { start: last_appt[:start], end: this_appt[:end] }
      else
        appts_so_far << last_appt << this_appt
      end
    end
  end

  def self.appts_to_schedlogic(appts)
    appts = appts.map(&:to_schedlogic)
    if appts.count > 1
      Day.merge_overlapping_appts(appts)
    else
      appts
    end
  end

  def self.tasks_to_schedlogic(tasks)
    tasks.map(&:to_schedlogic)
  end

  def self.to_schedlogic_json(tasks, appts, n)
    ActiveSupport::JSON.encode({ tasks: Day.tasks_to_schedlogic(tasks),
                                 appts: Day.appts_to_schedlogic(appts),
                                 n_schedules: n + 1 })
  end

  def self.schedlogic(tasks, appts, n)
    day_json = Day.to_schedlogic_json(tasks, appts, n)
    uri = URI(SCHEDLOGIC_URL)
    uri.query = URI.encode_www_form({ day: day_json })
    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      data = ActiveSupport::JSON.decode(response.body)
      if data == 'none'
        raise JoSched::ScheduleImpossibleException
      elsif data == 'failure'
        raise JoSched::ScheduleFailureException
      else
        data[n]['tasks']
      end
    else
      raise JoSched::ScheduleFailureException
    end
  end

  def self.schedule_day(tasks, appts, n)
    if tasks.any? {|t| t.start_min.blank? || t.end_min.blank? }
      tasks_data = Day.schedlogic(tasks, appts, n)
      tasks = tasks.map do |task|
        task_data = tasks_data.find {|t| t['id'] == task.id }
        task.schedule(task_data['start'], task_data['end'])
      end
    end

    (tasks + appts).sort_by(&:start_min)
  end

  def self.find(date, user)
    unless date.instance_of? Date
      date = Day.parse_date(date)
      raise ActiveRecord::RecordNotFound unless date
    end

    appts = user.appointments.find_all_by_date(date,
                                               order: 'start_min ASC')
    tasks = user.tasks.find_all_by_date(date)

    events = Day.schedule_day(tasks, appts, 0)
    Day.add_free_times(events)
  end
end
