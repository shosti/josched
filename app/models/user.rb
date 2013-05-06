class User < ActiveRecord::Base
  include Clearance::User

  has_many :appointments
  has_many :tasks
  has_many :events

  def day(date)
    self.events.find_all_by_date(date.to_date, order: 'start_min ASC')
  end
end
