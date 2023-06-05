FactoryBot.define do
  factory :merchant do
    name { "Merchant" }
    email { "merchant@merchant.com" }
    status { :active }
    total_transaction_sum { 1 }
    type { 'Merchant' }
    password { 'password' }
  end
end
