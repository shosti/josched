class PseudoEvent < Event
  attr_accessible :start_min, :end_min

  def saveable?
    false
  end

  def self.free_time(start_min, end_min)
    e = PseudoEvent.new(name: 'Free',
                        start_min: start_min,
                        end_min: end_min)
  end
end
