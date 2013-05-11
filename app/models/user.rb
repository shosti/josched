class User < ActiveRecord::Base
  include Clearance::User

  has_many :appointments, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :events, dependent: :destroy

  def unschedule_tasks(date)
    self.tasks.find_all_by_date(date).each do |task|
      task.unschedule
      task.save!
    end
  end
end
