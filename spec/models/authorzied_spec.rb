require 'rails_helper'

RSpec.describe Authorized, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).only_integer.is_greater_than(0) }
    it { should validate_presence_of(:customer_email) }
    it { should validate_length_of(:customer_email).is_at_least(5) }
    it { should validate_presence_of(:customer_phone) }
    it { should validate_length_of(:customer_phone).is_at_least(5) }
  end

  describe 'Factory' do
    it 'is valid' do
      expect(build(:authorized)).to be_valid
    end
  end

  describe '::method' do
    let(:merchant) { create(:merchant) }
    let(:authorized) { create(:authorized, merchant: merchant) }
    let(:charged) { create(:charged, authorized: authorized, merchant: merchant) }

    context 'expired scope' do
      before { create(:refunded, charged: charged, merchant: merchant) }

      it 'should destroy expired authorized transactions' do
        Timecop.travel(1.hour.from_now)

        expect {
          Authorized.expired.destroy_all
        }.to change { Transact.count }.from(3).to(0)
      end
    end
  end
end
