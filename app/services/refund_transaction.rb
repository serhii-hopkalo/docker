class RefundTransaction < ApplicationService
  def call
    super

    check_charged!

    if refunded.save
      Charged.where(id: context.transaction[:referenced_transaction_uuid]).update(status: :refunded)

      context.transaction = refunded
    else
      context.fail!(errors: refunded.errors.full_messages)
    end
  end

  private

  def check_charged!
    charged = Charged.find_by(id: context.transaction[:referenced_transaction_uuid])

    if charged.blank?
      context.fail!(
        errors: "Could not find Authorized transaction with given uuid #{context.transaction[:referenced_transaction_uuid]}"
      )
    end

    unless charged.approved?
      context.fail!(errors: "Referenced transaction does not has approved status")
    end
  end

  def refunded
    return @refunded if defined? @refunded

    @refunded = Refunded.new(
      merchant: context.merchant,
      amount: context.transaction[:amount],
      customer_email: context.transaction[:customer_email],
      customer_phone: context.transaction[:customer_phone],
      transact_id: context.transaction[:referenced_transaction_uuid],
      status: :refunded,
    )
  end
end
