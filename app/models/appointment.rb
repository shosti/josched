class Appointment < Event
  validates :start_time, presence: true
  validates :end_time, presence: true

  def saveable?
    true
  end

  def to_schedlogic
    start_quart = start_min / MINUTES_IN_QUART
    end_quart = end_min / MINUTES_IN_QUART +
      (end_min % MINUTES_IN_QUART == 0 ? 0 : 1)

    { start: start_quart,
      end: (end_quart == 0 ? 24 * QUARTS_IN_HOUR : end_quart) }
  end
end
