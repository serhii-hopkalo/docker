require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'Validations' do
    it { should define_enum_for(:status).with_values(active: 0, inactive: 1) }
    it { should validate_numericality_of(:total_transaction_sum).is_greater_than_or_equal_to(0) }
  end

  describe 'Factory' do
    it 'is valid' do
      expect(build(:merchant)).to be_valid
    end
  end
end
