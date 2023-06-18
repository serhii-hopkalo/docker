class AuthorizeTransaction < ApplicationService
  def call
    super

    authorized = Authorized.new(
      merchant: context.merchant,
      amount: context.amount,
      customer_email: context.customer_email,
      customer_phone: context.customer_phone,
      status: :approved,
    )

    if authorized.save
      context.transaction = authorized
    else
      context.fail!(errors: authorized.errors.full_messages)
    end
  end
end
