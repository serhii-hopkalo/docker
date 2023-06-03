class ReversalTransaction < ApplicationService
  delegate :authorized, :user, to: :context

  def call
    super

    reversal = Reversal.build(
      merchant: context.user,
      charged: charged
    )

    if reversal.save
      context.refunded = reversal
      context.authorized.update!(status: :reversed)
    else
      context.fail!(errors: reversal.errors.full_messages)
    end
  end

  private

  def validate
    if context.authorized.reversal.present?
      context.fail!(errors: ["The transaction is already reversed!"])
    end
  end
end
