require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Database table' do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:description).of_type(:text) }
    it { should have_db_column(:email).of_type(:string).with_options(null: false) }
    it { should have_db_column(:type).of_type(:string) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }

    it { should have_db_column(:name).of_type(:string).with_options(null: false) }

    it { should have_db_index(:email).unique }
  end

  describe 'Validations' do
    subject { build(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
  end
end
