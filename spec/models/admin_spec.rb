require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'Factory' do
    it 'is valid' do
      expect(build(:admin)).to be_valid
    end
  end
end
