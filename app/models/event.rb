class Event < ActiveRecord::Base
  belongs_to :user
  attr_accessor :start_time, :end_time
  attr_accessible(:date,
                  :location,
                  :name,
                  :type,
                  :start_time,
                  :end_time,
                  :user_id)

  after_initialize :set_time_mins
  before_validation :set_time_mins
  validates :name, presence: true
  validates :date, presence: true
  validates :user_id, presence: true

  def start_time
    @start_time ||
      Event.min_to_time(self.date, self.start_min)
  end

  def end_time
    @end_time ||
      Event.min_to_time(self.date, self.end_min)
  end

  def self.time_to_min(time)
    time = Time.parse(time) if time.is_a? String
    time.hour * 60 + time.min
  end

  def self.min_to_time(date, min)
    if date && min
      date.to_date + min.minutes
    end
  end

  private

  def set_time_mins
    if start_time && start_time != ""
      self.start_min = Event.time_to_min self.start_time
    end

    if end_time && end_time != ""
      self.end_min = Event.time_to_min self.end_time
    end
  end
end
