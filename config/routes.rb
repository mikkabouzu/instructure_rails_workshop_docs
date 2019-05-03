# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'healthcheck#index'
  get :healthcheck, to: 'healthcheck#index'

  get 'todos/:id', to: 'todos#show'
  delete 'todos/:id', to: 'todos#destroy'
end
