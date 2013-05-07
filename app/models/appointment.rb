class Appointment < Event
  def saveable?
    true
  end

  validates :start_time, presence: true
  validates :end_time, presence: true
end
