require 'rails_helper'

RSpec.describe Api::TransactionsController, type: :controller do
  describe 'POST #create' do
    let(:merchant) { create(:merchant) }
    let(:token)    { JsonWebTokenService.encode({ email: merchant.email }) }
    let(:email)    { 'email@emerchantpay.com' }
    let(:uuid)     { '4e27bd01-471e-426a-8f5a-b4b212caeb05' }
    let(:json)     { JSON.parse(response.body) }

    before { request.headers['Authorization'] = "Token #{token}" }

    context 'with valid parameters' do
      let(:transaction_params) do
        {
          transaction: {
            amount: 10,
            customer_email: email,
            customer_phone: 'phonenumber',
            type: :authorize,
            referenced_transaction_uuid: '4e27bd01-471e-426a-8f5a-b4b212caeb05',
          }
        }
      end

      it 'creates a new transaction' do
        expect do
          post :create, params: transaction_params, format: :json
        end.to change(Authorized, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: transaction_params, format: :json
        expect(response).to have_http_status(:created)
      end

      it 'returns the authorized transaction as JSON' do
        post :create, params: transaction_params, format: :json
        transact = Authorized.last

        expect(json['uuid']).to eq(transact.id)
      end
    end

    context 'with invalid parameters' do
      let(:transaction_params) do
        {
          transaction: {
            amount: -10,
            customer_email: email,
            customer_phone: 'phonenumber',
            type: :authorize,
            referenced_transaction_uuid: uuid
          }
        }
      end

      it 'does not create a new transaction' do
        expect do
          post :create, params: transaction_params, format: :json
        end.not_to change(Authorized, :count)
      end

      it 'returns an error response' do
        post :create, params: transaction_params, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error messages as JSON' do
        post :create, params: transaction_params, format: :json
        expect(response.body).to eq({ errors: ['amount must be greater than 0'] }.to_json)
      end
    end
  end
end
