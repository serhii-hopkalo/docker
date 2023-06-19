class ApplicationService
  class ServiceException < StandardError; end

  include Interactor

  def call
    check_merchant!

    context.fail!(errors: validation.errors(full: true).to_h.values) if validation.failure?
  end

  def check_merchant!
    if context.merchant.admin?
      context.fail!(errors: "Admins are not allowed to make transactions")
    end

    if context.merchant.merchant? && context.merchant.inactive?
      context.fail!(errors: "Merchant is not active")
    end
  end

  def validation
    return @validation if defined? @validation

    @validation = TransactionValidator.new.call(context.transaction)
  end
end
