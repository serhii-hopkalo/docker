class AuthorizeTransaction < ApplicationService
  delegate :amount, :customer_email, :customer_phone, :user, to: :context

  def call
    super

    authorized = Authorized.build(
      merchant: context.user,
      amount: context.amount,
      customer_email: context.customer_email,
      customer_phone: context.customer_phone,
    )

    if authorized.save
      context.transaction = authorized
    else
      context.fail!(errors: authorized.errors.full_messages)
    end
  end
end
