require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe 'Factory' do
    it 'is valid' do
      expect(build(:admin_user)).to be_valid
    end
  end
end
