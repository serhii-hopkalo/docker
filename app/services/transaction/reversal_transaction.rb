module Transaction
  class ReversalTransaction < BaseService
    def call
      super

      check_authorized!

      if reversal.save
        authorized.update(status: :reversed)

        context.transaction = reversal
      else
        context.fail!(errors: reversal.errors.full_messages)
      end
    end

    private

    def authorized
      return @authorized if defined? @authorized

      @authorized = Authorized.find_by(id: context.transaction[:referenced_transaction_uuid])
    end

    def check_authorized!
      if authorized.blank?
        context.fail!(
          errors: "Could not find Authorized transaction with given uuid #{context.transaction[:referenced_transaction_uuid]}"
        )
      end

      unless authorized.approved?
        context.fail!(errors: "Referenced transaction does not has approved status")
      end
    end

    def reversal
      return @reversal if defined? @reversal

      @reversal = Reversal.new(
        merchant: context.merchant,
        amount: context.transaction[:amount],
        customer_email: context.transaction[:customer_email],
        customer_phone: context.transaction[:customer_phone],
        transact_id: context.transaction[:referenced_transaction_uuid],
        status: :reversed,
      )
    end
  end
end
