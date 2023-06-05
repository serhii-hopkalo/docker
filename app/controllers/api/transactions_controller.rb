class Api::TransactionsController < ApplicationController
  skip_forgery_protection

  before_action :authenticate

  respond_to :json

  def create
    result = service.call(transaction_params.merge(merchant: current_merchant))

    if result.success?
      render json: result.transaction, status: :created, serializer: AuthorizedSerializer
    else
      render json: { errors: result.errors.first }, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    # TODO: get list of parameters from TransactionValidator
    # params.require(:transaction).permit(*TransactionValidator.parameters)
    params
      .require(:transaction)
      .permit(:amount, :customer_email, :customer_phone, :type, :referenced_transaction_uuid)
      .to_h
  end

  def service
    "#{transaction_params[:type].to_s.camelize}Transaction".constantize
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      Merchant.find_by(email: JsonWebTokenService.decode(token)['email'])
    end
  end

  def current_merchant
    return @current_merchant if defined? @current_merchant

    @current_user ||= authenticate
  end
end
