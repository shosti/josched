FactoryGirl.define do
  sequence :name do |n|
    "event #{n}"
  end

  sequence :date do |n|
    n.days.ago
  end

  factory :appointment do
    name
    start_time '3:00 PM'
    end_time '5:00 PM'
    date
    user
  end

  factory :pseudo_event do
    name
    start_time '3:00 PM'
    end_time '5:00 PM'
    date
    user
  end

  factory :task do
    name
    earliest '10:00 AM'
    latest '11:00 AM'
    length 4
    date
    user
  end
end
