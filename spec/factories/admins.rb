FactoryBot.define do
  factory :admin do
    name { "Admin" }
    description { "admin" }
    email { "admin@merchant.com" }
    status { :active }
    total_transaction_sum { 1 }
    type { 'Merchant' }
  end
end
