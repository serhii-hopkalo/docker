class SessionsController < ApplicationController
  def create
    merchant = Merchant.find_for_authentication(email: params[:email])

    if merchant
      if merchant.valid_password?(params[:password])
        render json: { auth_token: JsonWebTokenService.encode({ email: merchant.email }) }
      else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    else
      render json: { error: "Invalid email" }, status: :not_found
    end
  end
end
