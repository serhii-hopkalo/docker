require 'rails_helper'

RSpec.describe AuthorizeTransaction do
  include_context 'transaction params', AuthorizeTransaction
  it_behaves_like 'authorization protectable', AuthorizeTransaction
end
