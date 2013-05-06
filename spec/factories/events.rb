FactoryGirl.define do
  sequence :name do |n|
    "event #{n}"
  end

  sequence :date do |n|
    n.days.ago
  end

  factory :appointment do
    name
    start_min 0
    end_min 60
    date
    user
  end
end
