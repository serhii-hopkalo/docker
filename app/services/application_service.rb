class ApplicationService
  class ServiceException < StandardError; end

  include Interactor

  def self.call(*args)
    new(*args).call
  end

  def call
    return if context.user.admin?

    if context.user.merchant? && context.user.inactive?
      context.fail!(errors: ["Merchant is not active"])
    end

    validate
  end

  private

  def validate
    raise ServiceException, 'validate method is not implemented'
  end
end
