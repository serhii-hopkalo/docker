require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    let(:merchant) { create(:merchant) } # Assuming you have a factory for creating a merchant
    let(:json_response) { JSON.parse(response.body) }
    let(:content_type) { 'application/json; charset=utf-8' }

    context 'with valid credentials' do
      it 'returns a valid auth token' do
        post :create, format: :json, params: { email: merchant.email, password: 'password' }
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq(content_type)

        expect(json_response['auth_token']).not_to be_nil
      end
    end

    context 'with invalid password' do
      it 'returns an unauthorized error' do
        post :create, format: :json, params: { email: merchant.email, password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq(content_type)

        expect(json_response['error']).to eq('Invalid email or password')
      end
    end

    context 'with invalid email' do
      it 'returns a not found error' do
        post :create, format: :json, params: { email: 'invalid_email@example.com', password: 'password' }
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq(content_type)

        expect(json_response['error']).to eq('Invalid email')
      end
    end
  end
end
