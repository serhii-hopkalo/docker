require 'rails_helper'

RSpec.describe DeleteMerchantService do
  describe 'Prevent a merchant from being deleted unless there are no related payment transactions' do
    let(:merchant) { create(:merchant) }

    subject { DeleteMerchantService.call(merchant_id: merchant.id) }

    before do
      authorized = create(:authorized, merchant: merchant)
      charged = create(:charged, authorized: authorized, merchant: merchant)
      create(:refunded, charged: charged, merchant: merchant)
    end

    context 'there are no related transactions' do
      before { Transact.destroy_all }

      it 'should destroy merchant' do
        expect(subject.success?).to be_truthy
      end
    end

    context 'there are related transactions' do
      it 'should prevent merchant from destroy' do
        expect(subject.failure?).to be_truthy
        expect(subject.error).to eq("Merchant #{merchant.id} still has related payment transactions")
      end
    end
  end
end
