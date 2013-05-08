class Task < Event
  # belongs_to :user
  attr_writer :earliest, :latest, :length, :time_units
  attr_accessible(:earliest,
                  :latest,
                  :earliest_quart,
                  :latest_quart,
                  :length,
                  :length_quart,
                  :time_units)

  before_validation :normalize_time_units

  validates :earliest_quart, presence: true
  validates :latest_quart, presence: true
  validates :length_quart, presence: true
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

  private

  def earliest_and_latest_must_be_valid_times
    if self.earliest_quart >= self.latest_quart
      errors.add(:latest, "must be after earliest")
    end

    if self.earliest_quart >= 24 * QUARTS_IN_HOUR
      errors.add(:earliest, "is an invalid time")
    end

    if self.latest_quart > 24 * QUARTS_IN_HOUR
      errors.add(:latest, "is an invalid time")
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
    end

    unless @earliest.blank?
      minutes = Event.time_to_min(@earliest)
      self.earliest_quart = minutes / MINUTES_IN_QUART +
        (minutes % MINUTES_IN_QUART == 0 ? 0 : 1)
    end

    unless @latest.blank?
      minutes = Event.time_to_min(@latest)
      quarts = minutes / MINUTES_IN_QUART
      # 4:00 AM as a latest time = 96 quarters
      self.latest_quart = (quarts == 0 ? 24 * QUARTS_IN_HOUR : quarts)
    end
  end
end
