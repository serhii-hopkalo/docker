require 'csv'

namespace :seed do
  desc 'Seed database from CSV file'
  task users: :environment do
    file_path = Rails.root.join('db', 'seeds', 'users.csv')

    CSV.foreach(file_path, headers: true) do |row|
      User.create!(
        name: row['name'],
        description: row['description'],
        email: row['email'],
        status: row['status'],
        type: convert_type(row['type']),
        password: 'password',
      )
    end

    puts 'Seed data successfully imported.'
  end

  def convert_type(string)
    {
      'admin' => 'AdminUser',
      'merchant' => 'Merchant'
    }[string]
  end
end
