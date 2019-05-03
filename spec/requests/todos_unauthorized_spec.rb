# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'todos unauthorized' do
  describe 'GET /todos' do
    it 'responds with http 401' do
      get '/todos'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /todos' do
    it 'responds with http 401' do
      post '/todos'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /todos/:id' do
    it 'responds with http 401' do
      get '/todos/42'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PUT /todos/:id' do
    it 'responds with http 401' do
      put '/todos/42'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE /todos/:id' do
    it 'responds with http 401' do
      delete '/todos/42'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
