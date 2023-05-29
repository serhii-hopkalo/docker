class RefundTransaction < ApplicationService
  delegate :charged, :user, to: :context

  def call
    super

    refunded = Refunded.build(
      merchant: context.user,
      charged: charged
    )

    if refunded.save
      context.refunded = refunded
      context.authorized.update!(status: :refunded)
    else
      context.fail!(errors: refunded.errors.full_messages)
    end
  end

  private

  def validate
    if context.charged.refund.present?
      context.fail!(errors: ["The transaction is already refunded!"])
    end

    # TODO: check merchant's account
  end
end
