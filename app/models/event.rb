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
  before_validation :normalize_date
  validates :name, presence: true
  validates :date, presence: true
  validates :user_id, presence: true

  def start_time
    @start_time ||
      Event.min_to_time(self.start_min)
  end

  def end_time
    @end_time ||
      Event.min_to_time(self.end_min)
  end

  MINUTES_IN_DAY = 24 * 60
  FOUR_AM = 4 * 60

  def self.time_to_min(time)
    unless time.blank?
      time = Time.parse(time) if time.is_a? String
      (time.hour * 60 + time.min - FOUR_AM) % MINUTES_IN_DAY
    end
  end

  def self.min_to_time(min)
    unless min.blank?
      day_mins = (min + FOUR_AM) % MINUTES_IN_DAY
      (Date.today + day_mins.minutes).strftime('%l:%M %p').strip
    end
  end

  private

  def normalize_date
    unless self.date.blank?
      unless self.date.is_a? Date
        self.date = self.date.to_date
      end
    end
  end

  def set_time_mins
    unless self.start_time.blank?
      self.start_min = Event.time_to_min self.start_time
    end

    unless self.start_time.blank?
      self.end_min = Event.time_to_min self.end_time
    end
  end
end
