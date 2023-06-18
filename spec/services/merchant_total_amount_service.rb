require 'rails_helper'

RSpec.describe MerchantTotalAmountService do
  describe 'The merchants total transactions amount has to be the sum of the approved Charge transactions' do
    let(:merchant1) { create(:merchant) }
    let(:merchant2) { create(:merchant) }

    before do
      authorized = create(:authorized, merchant: merchant1, amount: 10)
      create(:charged, authorized: authorized, merchant: merchant1, amount: 10)
      authorized = create(:authorized, merchant: merchant1, amount: 20)
      create(:charged, authorized: authorized, merchant: merchant1, amount: 20)

      authorized = create(:authorized, merchant: merchant2, amount: 30)
      create(:charged, authorized: authorized, merchant: merchant2, amount: 30)
      authorized = create(:authorized, merchant: merchant2, amount: 40)
      create(:charged, authorized: authorized, merchant: merchant2, amount: 40)
    end

    it 'should adds up all chanrged transactions for specific merchant' do
      MerchantTotalAmountService.call(merchant_id: merchant1.id)
      MerchantTotalAmountService.call(merchant_id: merchant2.id)

      expect(merchant1.reload.total_transaction_sum).to eq(30)
      expect(merchant2.reload.total_transaction_sum).to eq(70)
    end
  end
end
