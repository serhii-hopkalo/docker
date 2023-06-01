class ChargeTransaction < ApplicationService
  delegate :authorized, :user, to: :context

  def call
    super

    charged = Charged.build(
      merchant: context.user,
      authorized: authorized
    )

    # TODO: check customer's account

    if charged.save
      context.transaction = charged
    else
      context.fail!(errors: charged.errors.full_messages)
    end
  end
end
