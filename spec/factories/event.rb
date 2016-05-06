FactoryGirl.define do
  factory :event, :class => 'Event' do
    name { Faker::Name.title }
    description { Faker::Lorem.paragraph }
    date { Faker::Time.forward(23, :morning) }
    paid_type "free"
    add_all_users false
    calculate_amount false
  end

  factory :paid_event, parent: :event do
    paid_type "paid"
    calculate_amount true
  end
end