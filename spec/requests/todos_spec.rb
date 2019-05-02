# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'todos' do
  describe 'GET /todos/:id' do
    context 'when there is a todo with the specified id' do
      let!(:todo) { create(:todo) }

      it 'responds with http 200' do
        get "/todos/#{todo.id}"
        expect(response).to have_http_status(:ok)
      end

      it 'responds with the todo as json' do
        get "/todos/#{todo.id}"
        expect(response.body).to eql(todo.to_json)
      end
    end

    context 'when there is no todo with the specified id' do
      it 'responds with http 404' do
        get '/todos/42'
        expect(response).to have_http_status(:not_found)
      end

      it 'responds with an error' do
        get '/todos/42'
        response_body = JSON.parse(response.body)
        expect(response_body).to eql('error' => 'not found')
      end
    end
  end
end
