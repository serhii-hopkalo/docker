class RefundTransaction < ApplicationService
  delegate :charged, :user, to: :context

  def call
    super

    refunded = Refunded.build(
      merchant: context.user,
      charged: charged
    )

    if refunded.save
      context.transaction = refunded
      context.authorized.update!(status: :refunded)
    else
      context.fail!(errors: refunded.errors.full_messages)
    end
  end
end
