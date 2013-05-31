require 'net/http'
require 'exceptions'

# A module for communicating with the SchedLogic API. Ideally, these
# methods should be called from a background worker process, since the
# SchedLogic API could potentially take a long time to respond (the
# current JoSched implementation calls them from the main Rails
# process, but hopefully this will change in the future).
module SchedLogic
  SCHEDLOGIC_URL = 'https://schedlogic.herokuapp.com/schedule'

  # `SchedLogic.schedule` takes an array of unscheduled tasks and an
  # array of appointments, and returns an array of task schedules
  # (represented as hashes corresponding to the input tasks)
  # representing the `n`th possible schedule. Tasks and appointments
  # must respond to `to_schedlogic`, which outputs a format that the
  # SchedLogic API understands (with times represented as
  # quarter-hours since the start of the day). If no schedule is
  # possible, a `SchedLogic::ScheduleImpossibleException` is thrown.
  # If the SchedLogic service fails to ouput any schedule (because of
  # time constraints or errors), a
  # `SchedLogic::ScheduleFailureException` is thrown.
  def self.schedule(tasks, appts, n)
    day_json = SchedLogic.to_schedlogic_json(tasks, appts, n)
    uri = URI(SCHEDLOGIC_URL)
    uri.query = URI.encode_www_form({ day: day_json })
    response = Net::HTTP.get_response(uri)
    if response.is_a? Net::HTTPSuccess
      data = ActiveSupport::JSON.decode(response.body)
      if data == 'none'
        raise SchedLogic::ScheduleImpossibleException
      elsif data == 'failure'
        raise SchedLogic::ScheduleFailureException
      else
        data[n]
      end
    else
      raise SchedLogic::ScheduleFailureException
    end
  end

  # The tasks and appointments are transformed to a JSON object that
  # the SchedLogic API understands.
  def self.to_schedlogic_json(tasks, appts, n)
    ActiveSupport::JSON.encode({
        tasks: SchedLogic.tasks_to_schedlogic(tasks),
        appts: SchedLogic.appts_to_schedlogic(appts),
        n_schedules: n + 1
      })
  end

  # Tasks can simply be transformed to SchedLogic objects, since their
  # internal representation is identical to the SchedLogic API
  # representation.
  def self.tasks_to_schedlogic(tasks)
    tasks.map(&:to_schedlogic)
  end

  # Appointments have an additional complication: their times are
  # stored within JoSched as minutes, but SchedLogic expects
  # quarter-hours. Since times are rounded outward, there is a
  # possibility that appointments will overlap, which the SchedLogic
  # service can't currently handle.
  def self.appts_to_schedlogic(appts)
    SchedLogic.merge_overlapping_appts(appts.map(&:to_schedlogic))
  end

  # To accomodate overlapping, appointments with overlapping times are
  # merged together.
  def self.merge_overlapping_appts(appts)
    if appts.count <= 1
      appts
    else
      appts[1..-1].inject([appts[0]]) do |appts_so_far, this_appt|
        last_appt = appts_so_far.pop
        if last_appt[:end] >= this_appt[:start]
          appts_so_far << {
            start: last_appt[:start],
            end: this_appt[:end]
          }
        else
          appts_so_far << last_appt << this_appt
        end
      end
    end
  end
end
