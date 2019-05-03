# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'healthcheck#index'
  get :healthcheck, to: 'healthcheck#index'

  get 'todos', to: 'todos#index'
  post 'todos', to: 'todos#create'
  get 'todos/:id', to: 'todos#show'
  put 'todos/:id', to: 'todos#update'
  delete 'todos/:id', to: 'todos#destroy'
end
