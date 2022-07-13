FactoryBot.define do
  factory :item do
    name { Faker::Camera.brand_with_model }
  end
end
