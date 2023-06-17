FactoryBot.define do
  factory :admin_user do
    name { "AdminUser" }
    email { Faker::Internet.unique.email }
    password { "password" }
  end
end
