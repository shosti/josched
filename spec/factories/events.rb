FactoryGirl.define do
  sequence :name do |n|
    "event #{n}"
  end

  sequence :date do |n|
    n.days.ago
  end

  factory :event do
    name
    user
    start_time '3:00 PM'
    end_time '5:00 PM'
    date
  end

  factory :appointment do
    name
    start_time '3:00 PM'
    end_time '5:00 PM'
    date
    user
  end
end
