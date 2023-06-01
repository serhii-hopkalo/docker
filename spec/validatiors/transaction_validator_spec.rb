require 'rails_helper'

RSpec.describe TransactionValidator do
  subject(:result) { described_class.new.call(data) }

  describe '#call' do
    context 'rule' do
      let(:data) do
        {
          amount: 100,
          customer_email: 'example@example.com',
          customer_phone: '123456789',
          type: type,
        }
      end

      context 'when authorize transaction' do
        let(:type) { 'authorize' }

        it { is_expected.to be_success }
      end

      context 'when other than authorize transaction' do
        ["charge", "refund", "reversal"].each do |t|
          let(:type) { t }

          it { is_expected.to be_failure }
        end
      end
    end
  end
end
