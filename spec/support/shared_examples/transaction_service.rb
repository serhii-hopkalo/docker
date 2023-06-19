RSpec.shared_examples 'authorization protectable' do |klass|
  before do
    transaction_params[:merchant] = current_user
  end

  describe 'admin can not make transaction' do
    let(:current_user) { admin }

    it 'fails' do
      expect(subject.failure?).to be_truthy
      expect(subject.errors).to eq("Admins are not allowed to make transactions")
    end
  end

  describe 'inactive merchant can not make transaction' do
    let(:current_user) { create(:merchant, status: :inactive) }

    it 'fails' do
      expect(subject.failure?).to be_truthy
      expect(subject.errors).to eq("Merchant is not active")
    end
  end
end
