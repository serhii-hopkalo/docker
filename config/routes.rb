Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: "pages#home"

  namespace :api, defaults: { format: :json } do
    resources :transactions, only: :create
  end

  post 'authenticate' => 'sessions#create'

  require "sidekiq/web"

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
end
