require 'factory_bot'

namespace :seed do
  desc "Seeds merchants and admin"
  task users: :environment do
    include FactoryBot::Syntax::Methods

    create(:admin_user)

    create(
      :merchant,
      name: 'Merchant 1',
      email: 'merchant@mail.com',
      status: :active,
      total_transaction_sum: 100,
      password: 'password'
    )
  end
end
