FactoryBot.define do
  factory :user do
    name { "Useruser" }
    sequence(:email) { |n| "merchant#{n}@merchant.com"}
    status { :active }
    total_transaction_sum { 1 }
    type { 'Merchant' }
    password { 'password' }
  end
end
