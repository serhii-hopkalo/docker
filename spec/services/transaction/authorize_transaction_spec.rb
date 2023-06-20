require 'rails_helper'

RSpec.describe Transaction::AuthorizeTransaction do
  include_context 'transaction params', Transaction::AuthorizeTransaction
  it_behaves_like 'authorization protectable', Transaction::AuthorizeTransaction
end
