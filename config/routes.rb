# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  scope module: :web do
    root 'posts#index'

    resources :posts, except: %i[edit update] do
      post :export, on: :collection, defaults: { format: 'xlsx' }
      member do
        patch :moderate
        patch :publish
        patch :reject
      end
    end
  end
end
