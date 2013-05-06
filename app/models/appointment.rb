class Appointment < Event
  validates :start_min, presence: true, inclusion: {
    in: (0..24.hours.to_i), message: "%{value} is not a valid time"
  }
  validates :end_min, presence: true, inclusion: {
    in: (0..24.hours.to_i), message: "%{value} is not a valid time"
  }
end
