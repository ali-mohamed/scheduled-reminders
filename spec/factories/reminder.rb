FactoryBot.define do
  factory :reminder do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    time { Faker::Time.forward(4, :morning) }
    user factory: :user
  end
end
