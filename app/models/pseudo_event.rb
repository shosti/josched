class PseudoEvent < Event
  attr_accessible :start_min, :end_min

  def saveable?
    false
  end

  def save!
    false
  end

  def save
    false
  end

  def self.free_time(start_min, end_min)
    PseudoEvent.new(name: 'Free',
                    start_min: start_min,
                    end_min: end_min)
  end

  def self.sleep_until(end_min)
    PseudoEvent.new(name: 'Sleep',
                    start_min: 0,
                    end_min: end_min)
  end

  def self.sleep_after(start_min)
    PseudoEvent.new(name: 'Sleep',
                    start_min: start_min,
                    end_min: 24 * 60)
  end
end
