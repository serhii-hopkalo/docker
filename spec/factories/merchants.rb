FactoryBot.define do
  factory :merchant do
    name { "Merchant" }
    email { Faker::Internet.unique.email }
    status { :active }
    total_transaction_sum { 1 }
    type { 'Merchant' }
    password { 'password' }
  end
end
