class AuthorizeTransaction < ApplicationService
  delegate :authorized, :user, to: :context

  def call
    super

    charged = Charged.build(
      merchant: context.user,
      authorized: authorized
    )

    if charged.save
      context.charged = charged
    else
      context.fail!(errors: charged.errors.full_messages)
    end
  end

  private

  def validate
    if context.authorized.charged.present?
      context.fail!(errors: ["The transaction is already charged!"])
    elsif context.authorized.reversal.present
      context.fail!(errors: ["The transaction is already reversed!"])
    end

    # TODO: check customer's account
  end
end
