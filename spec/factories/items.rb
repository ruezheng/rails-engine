FactoryBot.define do
  factory :item do
    name { Faker::Camera.brand }
    description { Faker::Camera.brand_with_model }
    unit_price { Faker::Number.between(from: 100, to: 5000) }
  end
end
