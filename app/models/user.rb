class User < ActiveRecord::Base
  include Clearance::User

  has_many :appointments
  has_many :tasks
  has_many :events


  def day(date)
    if date == 'today'
      date = Date.today
    elsif date.is_a? String
      date = Date.parse(date)
    else
      date = date.to_date
    end

    self.events.find_all_by_date(date)
  end
end
