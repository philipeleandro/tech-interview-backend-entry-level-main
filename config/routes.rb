# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'rails/health#show'

  devise_for :users

  post '/cart', to: 'carts#create'
  post '/cart/add_item', to: 'carts#update'
  get '/cart', to: 'carts#show'
  delete '/cart/:product_id', to: 'carts#delete'
end
