FactoryBot.define do
  factory :transact do
    association :merchant
    association :transact

    customer_email { Faker::Internet.email }
    customer_phone { Faker::PhoneNumber.cell_phone_in_e164 }
    status { Transact.statuses.keys.sample }
    amount { rand(1..100) }
  end
end
