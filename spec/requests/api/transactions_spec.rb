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

  describe 'Sequence of transactions' do
    let(:merchant) { create(:merchant) }
    let(:token)    { JsonWebTokenService.encode({ email: merchant.email }) }
    let(:email)    { 'email@emerchantpay.com' }
    let(:transaction_params) do
      {
        transaction: {
          amount: 10,
          customer_email: email,
          customer_phone: 'phonenumber',
        }
      }
    end

    def json
      JSON.parse(response.body)
    end

    def uuid
      json['uuid']
    end

    def status
      json['status']
    end

    def create_authorized_transaction(params)
      params[:transaction][:type] = :authorize

      post :create, params: params, format: :json
    end

    def create_charged_transaction(params)
      params[:transaction][:type] = :charge
      params[:transaction][:referenced_transaction_uuid] = uuid

      post :create, params: params, format: :json
    end

    def create_refund_transaction(params)
      params[:transaction][:type] = :refund
      params[:transaction][:referenced_transaction_uuid] = uuid

      post :create, params: params, format: :json
    end

    def create_reversal_transaction(params)
      params[:transaction][:type] = :reversal
      params[:transaction][:referenced_transaction_uuid] = uuid

      post :create, params: params, format: :json
    end

    before { request.headers['Authorization'] = "Token #{token}" }

    describe 'Refunded transactions' do
      describe 'Refunded transaction' do
        it 'creates a refunded transaction' do
          create_authorized_transaction(transaction_params)

          create_charged_transaction(transaction_params)

          create_refund_transaction(transaction_params)

          expect(status).to eq('refunded')
        end
      end
    end

    describe 'Reversal transactions' do
      it 'creates a reversal transaction' do
        create_authorized_transaction(transaction_params)

        create_reversal_transaction(transaction_params)

        expect(status).to eq('reversed')
      end
    end
  end
end
