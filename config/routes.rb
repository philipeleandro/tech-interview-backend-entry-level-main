# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'rails/health#show'

  devise_for :users

  post '/cart/add_item', to: 'carts#add_item'
  get '/cart', to: 'carts#show_cart'
end
