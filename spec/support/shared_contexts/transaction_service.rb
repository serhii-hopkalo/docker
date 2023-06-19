RSpec.shared_context 'transaction params' do |klass|
  let(:admin)    { create(:admin_user) }
  let(:merchant) { create(:merchant) }
  let(:email)    { 'email@emerchantpay.com' }
  let(:transaction_params) do
    {
      transaction: {
        amount: 10,
        customer_email: email,
        customer_phone: 'phonenumber',
        type: 'authorize',
        referenced_transaction_uuid: '4e27bd01-471e-426a-8f5a-b4b212caeb05',
      }
    }
  end

  subject { klass.call(transaction_params) }
end
