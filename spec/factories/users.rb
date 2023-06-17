FactoryBot.define do
  factory :user do
    name { "Useruser" }
    email { Faker::Internet.unique.email }
    description { Faker::Lorem.sentence }
    status { :active }
    total_transaction_sum { 1 }
    type { 'Merchant' }
    password { 'password' }
  end
end
