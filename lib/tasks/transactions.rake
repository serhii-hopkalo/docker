require 'net/http'
require 'json'
require 'csv'

namespace :seed do
  desc "Make JSON requests to seed up transactions"
  task transactions: :environment do
    def make_request(uri, body, token=nil)
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/json'
      request.body = body.to_json

      request['Authorization'] = "Token token=#{token}" if token

      Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(request) }
    end

    # Authentication
    response = make_request(
      URI('http://localhost:8000/authenticate'),
      { email: 'merchant@mail.com', password: 'password' }
    )

    token = JSON.parse(response.body)['auth_token']

    uri = URI('http://localhost:8000/api/transactions')

    csv_file_path = Rails.root.join('db', 'seeds', 'transactions.csv')

    CSV.foreach(csv_file_path, headers: true) do |row|
      body = {
        amount: row['amount'].to_i, # cents
        type:   row['type'],
        customer_email: row['customer_email'],
        customer_phone: row['customer_phone'],
        referenced_transaction_uuid: row['referenced_transaction_uuid']
      }.compact

      make_request(uri, body, token)
    end
  end
end


