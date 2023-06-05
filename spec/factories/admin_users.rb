FactoryBot.define do
  factory :admin_user do
    name { "Admin" }
    sequence(:email) { |n| "admin#{n}@mail.com" }
    password { "password" }
  end
end
