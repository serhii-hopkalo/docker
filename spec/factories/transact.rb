FactoryBot.define do
  factory :transact do
    association :merchant
    association :transact

    sequence :customer_email do |n|
      "transact#{n}@merchant.com"
    end
    customer_phone { Faker::PhoneNumber.cell_phone_in_e164 }
    status { Transact.statuses.keys.sample }
    amount { rand(1..100) }
  end

  factory :authorized do
    association :merchant

    sequence :customer_email do |n|
      "authorized#{n}@merchant.com"
    end
    customer_phone { Faker::PhoneNumber.cell_phone_in_e164 }
    status { :approved }
    amount { rand(1..100) }
  end

  factory :charged do
    association :merchant
    association :authorized

    sequence :customer_email do |n|
      "charged#{n}@merchant.com"
    end
    customer_phone { Faker::PhoneNumber.cell_phone_in_e164 }
    amount { rand(1..100) }
    status { :approved }
  end

  factory :refunded do
    association :merchant
    association :charged

    sequence :customer_email do |n|
      "charged#{n}@merchant.com"
    end

    amount { rand(1..100) }
    status { :approved }
  end

  factory :reversal do
    association :merchant
    association :authorized

    status { :approved }
  end
end
