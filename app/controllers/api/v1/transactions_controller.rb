class Api::V1::TransactionsController < ApplicationController::API
  def create
    result = service.call(transaction_params)

    if result.success?
      render json: result.authorize, status: :created
    else
      render json: result.errors, status: result.status
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(*TansactionValidator.params.types.keys)
  end

  def type
    transaction_params[:type]
  end

  def service
    "#{type.to_s.camelize}Transaction".constantize
  end
end
