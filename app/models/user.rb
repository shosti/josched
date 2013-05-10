class User < ActiveRecord::Base
  include Clearance::User

  has_many :appointments, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :events, dependent: :destroy

end
