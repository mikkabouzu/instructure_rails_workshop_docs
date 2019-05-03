# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'todos' do
  describe 'GET /todos' do
    context 'when there are no todos' do
      it 'responds with http 200' do
        get '/todos'
        expect(response).to have_http_status(:ok)
      end

      it 'responds with an empty array as json' do
        get '/todos'
        response_body = JSON.parse(response.body)
        expect(response_body).to eql([])
      end
    end

    context 'when there are some todos' do
      let!(:todos) { create_list(:todo, 3) }

      it 'responds with http 200' do
        get '/todos'
        expect(response).to have_http_status(:ok)
      end

      it 'responds with the todos in an array' do
        get '/todos'
        response_body = JSON.parse(response.body)
        expect(response_body.count).to eq(todos.count)
      end
    end
  end

  describe 'POST /todos' do
    context 'with valid parameters' do
      let(:valid_params) { { title: 'just do it' } }

      it 'responds with http 201' do
        post '/todos', params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'creates a todo' do
        expect { post '/todos', params: valid_params }.to change(Todo, :count).by(1)
      end

      it 'responds with the newly created todo' do
        post '/todos', params: valid_params
        expect(response.body).to eql(Todo.last.to_json)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { something: 'irrelevant' } }

      it 'responds with http bad request' do
        post '/todos', params: invalid_params
        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with an error' do
        post '/todos', params: invalid_params
        response_body = JSON.parse(response.body)
        expect(response_body).to eql('error' => 'bad request')
      end
    end
  end

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

  describe 'DELETE /todos/:id' do
    context 'when there is a todo with the specified id' do
      let!(:todo) { create(:todo) }

      it 'responds with http 204' do
        delete "/todos/#{todo.id}"
        expect(response).to have_http_status(:no_content)
      end

      it 'deletes the todo' do
        expect { delete "/todos/#{todo.id}" }.to change { Todo.exists?(todo.id) }.from(true).to(false)
      end
    end

    context 'when there is no todo with the specified id' do
      it 'responds with http 404' do
        delete '/todos/42'
        expect(response).to have_http_status(:not_found)
      end

      it 'responds with an error' do
        delete '/todos/42'
        response_body = JSON.parse(response.body)
        expect(response_body).to eql('error' => 'not found')
      end
    end
  end
end
