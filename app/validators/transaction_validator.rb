class TransactionValidator < Dry::Validation::Contract
  UUID_REGEX = /\A[a-f0-9]{8}-[a-f0-9]{4}-[4][a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}\z/i
  error_message = "For %s transaction the referenced_transaction_uuid should be provided".freeze

  params do
    required(:amount).filled(:integer, gt?: 0)
    required(:customer_email).filled(:string)
    required(:customer_phone).filled(:string)
    required(:type).filled(:string, included_in?: ["authorize", "charge", "refund", "reversal"])
    optional(:referenced_transaction_uuid).filled(format?: UUID_REGEX)
  end

  rule(:referenced_transaction_uuid) do
    if values[:type] != 'authorize' && !values.has_key?(:referenced_transaction_uuid)
      key.failure(error_message % values[:type].camelize)
    end
  end
end
