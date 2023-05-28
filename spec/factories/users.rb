FactoryBot.define do
  factory :user do
    name { "User" }
    description { "user" }
    email { "user@merchant.com" }
    status { :active }
    total_transaction_sum { 1 }
    type { 'Merchant' }
  end
end
