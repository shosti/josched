class Task < Event
  belongs_to :user
  attr_writer :earliest, :latest, :length, :time_units
  attr_accessible(:earliest,
                  :latest,
                  :earliest_quart,
                  :latest_quart,
                  :length,
                  :length_quart,
                  :time_units)

  before_validation :normalize_time_units
  after_validation :unschedule_if_necessary

  validates :earliest, presence: true
  validates :latest, presence: true
  validates :length, presence: true
  validate :earliest_and_latest_must_be_valid_times

  def saveable?
    true
  end

  def earliest
    @earliest ||
      (Event.min_to_time(earliest_quart * MINUTES_IN_QUART) if earliest_quart)
  end

  def latest
    @latest ||
      (Event.min_to_time(latest_quart * MINUTES_IN_QUART) if latest_quart)
  end

  def length
    if @length
      @length
    elsif length_quart
      if time_units == 'hours'
        length_quart.to_d / QUARTS_IN_HOUR
      else
        length_quart * MINUTES_IN_QUART
      end
    end
  end

  def time_units
    if @time_units
      @time_units
    elsif length_quart
      if length_quart >= 4
        'hours'
      else
        'minutes'
      end
    end
  end

  def to_schedlogic
    { earliest: earliest_quart,
      latest: latest_quart,
      length: length_quart,
      id: id }
  end

  def schedule(start_quart, end_quart)
    self.start_min = start_quart * MINUTES_IN_QUART
    self.end_min = end_quart * MINUTES_IN_QUART
    self
  end

  def unschedule
    self.start_min = nil
    self.end_min = nil
    @start_time = nil
    @end_time = nil
    self
  end

  def self.schedule_task(task_data)
    task = Task.find(task_data['id'])
    task.schedule(task_data['start'], task_data['end'])
    task.save!
    task
  end

  private

  def unschedule_if_necessary
    if self.start_min && self.end_min
      start_quart = self.start_min / MINUTES_IN_QUART
      end_quart = self.end_min / MINUTES_IN_QUART

      unschedule_necessary =
        (start_quart < earliest_quart) ||
        (end_quart > latest_quart) ||
        (end_quart - start_quart != length_quart)

      unschedule if unschedule_necessary
    end
  end

  def earliest_and_latest_must_be_valid_times
    if self.earliest_quart && self.latest_quart
      if self.earliest_quart >= self.latest_quart
        errors.add(:latest, 'must be after earliest')
      end

      if self.earliest_quart >= 24 * QUARTS_IN_HOUR
        errors.add(:earliest, 'is an invalid time')
      end

      if self.latest_quart > 24 * QUARTS_IN_HOUR
        errors.add(:latest, 'is an invalid time')
      end
    end
  end

  def normalize_time_units
    unless @length.blank?
      if time_units == 'hours'
        self.length_quart =
          (@length.to_d * QUARTS_IN_HOUR).ceil
      else
        self.length_quart = (@length.to_f / MINUTES_IN_QUART).ceil
      end
      @length = nil
    end

    unless @earliest.blank?
      minutes = Event.time_to_min(@earliest)
      self.earliest_quart = minutes / MINUTES_IN_QUART +
        (minutes % MINUTES_IN_QUART == 0 ? 0 : 1)
      @earliest = nil
    end

    unless @latest.blank?
      minutes = Event.time_to_min(@latest)
      quarts = minutes / MINUTES_IN_QUART
      # 4:00 AM as a latest time = 96 quarters
      self.latest_quart = (quarts == 0 ? 24 * QUARTS_IN_HOUR : quarts)
      @latest = nil
    end
  end
end
