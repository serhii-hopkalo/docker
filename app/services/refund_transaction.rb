class RefundTransaction < ApplicationService
  def call
    super

    check_charged!

    if refunded.save
      Charged.where(id: context.referenced_transaction_uuid).update(status: :refunded)

      context.transaction = refunded
    else
      context.fail!(errors: refunded.errors.full_messages)
    end
  end

  private

  def check_charged!
    charged = Charged.find_by(id: context.referenced_transaction_uuid)

    if charged.blank?
      context.fail!(
        errors: "Could not find Authorized transaction with given uuid #{context.referenced_transaction_uuid}"
      )
    end

    unless charged.approved?
      context.fail!(errors: ["Referenced transaction does not has approved status"])
    end
  end

  def refunded
    return @refunded if defined? @refunded

    @refunded = Refunded.new(
      merchant: context.merchant,
      amount: context.amount,
      customer_email: context.customer_email,
      customer_phone: context.customer_phone,
      status: :refunded,
      transact_id: context.referenced_transaction_uuid
    )
  end
end
