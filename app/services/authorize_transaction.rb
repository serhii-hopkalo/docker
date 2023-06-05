class AuthorizeTransaction < ApplicationService
  delegate :amount, :customer_email, :customer_phone, :merchant, to: :context

  def call
    super

    authorized = Authorized.new(
      merchant: context.merchant,
      amount: context.amount,
      customer_email: context.customer_email,
      customer_phone: context.customer_phone,
      status: :authorize,
    )

    if authorized.save
      context.transaction = authorized
    else
      context.fail!(errors: authorized.errors.full_messages)
    end
  end
end
