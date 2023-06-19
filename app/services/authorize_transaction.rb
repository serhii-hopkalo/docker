class AuthorizeTransaction < ApplicationService
  def call
    super

    if authorized.save
      context.transaction = authorized
    else
      context.fail!(errors: authorized.errors.full_messages)
    end
  end

  private

  def authorized
    return @authorized if defined? @authorized

    @authorized = Authorized.new(
      merchant: context.merchant,
      amount: context.transaction[:amount],
      customer_email: context.transaction[:customer_email],
      customer_phone: context.transaction[:customer_phone],
      status: :approved,
    )
  end
end
