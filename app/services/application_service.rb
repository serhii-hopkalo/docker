class ApplicationService
  class ServiceException < StandardError; end

  include Interactor

  def call
    if context.user.admin?
      context.fail!(errors: ["Admins are not allowed to make transactions"])
    end

    if context.user.merchant? && context.user.inactive?
      context.fail!(errors: ["Merchant is not active"])
    end

    validation = TansactionValidator.new.call(context.to_h)

    if validation.failure?
      context.fail!(errors: validation.errors(full: true).to_h.values)
    end
  end
end
