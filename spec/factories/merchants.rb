FactoryBot.define do
  factory :merchant do
    name { "Merchant" }
    description { "merchant" }
    email { "merchant@merchant.com" }
    status { :active }
    total_transaction_sum { 1 }
    type { 'Merchant' }
  end
end
