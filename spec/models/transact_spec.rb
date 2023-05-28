require 'rails_helper'

RSpec.describe Transact, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).only_integer.is_greater_than(0) }
    it { should validate_presence_of(:customer_email) }
    it { should validate_length_of(:customer_email).is_at_least(5) }
    it { should validate_presence_of(:customer_phone) }
    it { should validate_length_of(:customer_phone).is_at_least(5) }
    it { should validate_presence_of(:status) }
  end

  describe 'Enums' do
    it { should define_enum_for(:status).with_values(authorize: 0, charge: 1, refund: 2, error: 3) }
  end

  describe 'Associations' do
    it { should belong_to(:merchant).with_foreign_key(:user_id) }
  end

  describe 'Factory' do
    it 'is valid' do
      expect(build(:transact)).to be_valid
    end
  end
end
