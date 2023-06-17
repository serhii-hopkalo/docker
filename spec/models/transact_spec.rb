require 'rails_helper'

RSpec.describe Transact, type: :model do
  let(:merchant) { create(:merchant) }
  let(:authorized) { create(:authorized, merchant: merchant) }

  describe 'Validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'Enums' do
    it { should define_enum_for(:status).with_values(authorize: 0, charge: 1, refund: 2, error: 3) }
  end

  describe 'Associations' do
    it { should belong_to(:merchant).with_foreign_key(:user_id) }
  end

  describe 'linked transactions' do
    let(:charged) { create(:charged, authorized: authorized, merchant: merchant) }

    context 'refunded' do
      before { create(:refunded, charged: charged, merchant: merchant) }

      it 'should destroy refunded, charged and authorized transaction' do
        expect {
          authorized.destroy
        }.to change { Transact.count }.from(3).to(0)
      end
    end

    context 'reversal' do
      before { create(:reversal, authorized: authorized, merchant: merchant) }

      it 'should destroy reversal and authorized transaction' do
        expect {
          authorized.destroy
        }.to change { Transact.count }.from(2).to(0)
      end
    end
  end

  describe 'Charged transaction' do
    let(:charged) { build(:charged, authorized: authorized, merchant: merchant) }

    it 'should call background job' do
      expect(ProcessMerchantTotalTransactionsAmount).to receive(:perform_later).with(merchant_id: merchant.id)

      charged.save!
    end
  end
end

