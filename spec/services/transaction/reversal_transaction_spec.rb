require 'rails_helper'

RSpec.describe Transaction::ReversalTransaction do
  include_context 'transaction params', Transaction::ReversalTransaction
  it_behaves_like 'authorization protectable', Transaction::ReversalTransaction

  describe 'checking referenced transaction' do
    let(:current_user) { create(:merchant) }

    before do
      transaction_params[:transaction][:referenced_transaction_uuid] = uuid
      transaction_params[:merchant] = current_user
    end

    context 'when authorized transaction is not valid' do
      let(:uuid) { '4e27bd01-471e-426a-8f5a-b4b212caeb05' }

      it 'fails' do
        expect(subject.failure?).to be_truthy
        expect(subject.errors).to eq("Could not find Authorized transaction with given uuid #{uuid}")
      end
    end

    context 'when authorized transaction has not approved status' do
      let(:authorized) { create(:authorized, status: :error) }
      let(:uuid) { authorized.id }

      it 'fails' do
        expect(subject.failure?).to be_truthy
        expect(subject.errors).to eq("Referenced transaction does not has approved status")
      end
    end
  end
end
