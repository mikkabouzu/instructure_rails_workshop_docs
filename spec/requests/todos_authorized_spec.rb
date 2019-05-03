# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'todos authorized' do
  let(:api_key) { 'some_key' }
  let(:headers) { { 'X_API_KEY' => api_key } }

  before { allow(Rails.configuration).to receive(:api_key).and_return(api_key) }

  describe 'GET /todos' do
    context 'when there are no todos' do
      it 'responds with http 200' do
        get '/todos', headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'responds with an empty array as json' do
        get '/todos', headers: headers
        response_body = JSON.parse(response.body)
        expect(response_body).to eql([])
      end
    end

    context 'when there are some todos' do
      let!(:completed_todos) { create_list(:todo, 2, :completed) }
      let!(:uncompleted_todos) { create_list(:todo, 4, :uncompleted) }
      let(:all_todos) { completed_todos + uncompleted_todos }

      it 'responds with http 200' do
        get '/todos', headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'responds with the todos in an array' do
        get '/todos', headers: headers
        response_body = JSON.parse(response.body)
        expect(response_body.count).to eq(all_todos.count)
      end

      it 'can be filtered for completed todos' do
        get '/todos', params: { completed: true }, headers: headers
        response_body = JSON.parse(response.body)
        aggregate_failures do
          expect(response_body.count).to eq(completed_todos.count)
          expect(response_body.map { |todo| todo['completed'] }.all?).to be_truthy
        end
      end

      it 'can be filtered for uncompleted todos' do
        get '/todos', params: { completed: false }, headers: headers
        response_body = JSON.parse(response.body)
        aggregate_failures do
          expect(response_body.count).to eq(uncompleted_todos.count)
          expect(response_body.map { |todo| todo['completed'] }.any?).to be_falsy
        end
      end
    end
  end

  describe 'POST /todos' do
    context 'with valid parameters' do
      let(:valid_params) { { title: 'just do it' } }

      it 'responds with http 201' do
        post '/todos', params: valid_params, headers: headers
        expect(response).to have_http_status(:created)
      end

      it 'creates a todo' do
        expect { post '/todos', params: valid_params, headers: headers }.to change(Todo, :count).by(1)
      end

      it 'responds with the newly created todo' do
        post '/todos', params: valid_params, headers: headers
        expect(response.body).to eql(Todo.last.to_json)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { something: 'irrelevant' } }

      it 'responds with http bad request' do
        post '/todos', params: invalid_params, headers: headers
        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with an error' do
        post '/todos', params: invalid_params, headers: headers
        response_body = JSON.parse(response.body)
        expect(response_body).to eql('error' => 'bad request')
      end
    end
  end

  describe 'GET /todos/:id' do
    context 'when there is a todo with the specified id' do
      let!(:todo) { create(:todo) }

      it 'responds with http 200' do
        get "/todos/#{todo.id}", headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'responds with the todo as json' do
        get "/todos/#{todo.id}", headers: headers
        expect(response.body).to eql(todo.to_json)
      end
    end

    context 'when there is no todo with the specified id' do
      it 'responds with http 404' do
        get '/todos/42', headers: headers
        expect(response).to have_http_status(:not_found)
      end

      it 'responds with an error' do
        get '/todos/42', headers: headers
        response_body = JSON.parse(response.body)
        expect(response_body).to eql('error' => 'not found')
      end
    end
  end

  describe 'PUT /todos/:id' do
    context 'when there is a todo with the specified id' do
      let!(:todo) { create(:todo, title: 'some todo') }

      context 'with valid parameters' do
        let(:valid_params) { { title: 'just do it' } }

        it 'responds with http 200' do
          put "/todos/#{todo.id}", params: valid_params, headers: headers
          expect(response).to have_http_status(:ok)
        end

        it 'updates the todo' do
          expect { put "/todos/#{todo.id}", params: valid_params, headers: headers }.to \
            change { todo.reload.title }.to(valid_params[:title])
        end

        it 'responds with the updated todo' do
          put "/todos/#{todo.id}", params: valid_params, headers: headers
          expect(response.body).to eql(todo.reload.to_json)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) { { title: '' } }

        it 'responds with http bad request' do
          put "/todos/#{todo.id}", params: invalid_params, headers: headers
          expect(response).to have_http_status(:bad_request)
        end

        it 'responds with an error' do
          put "/todos/#{todo.id}", params: invalid_params, headers: headers
          response_body = JSON.parse(response.body)
          expect(response_body).to eql('error' => 'bad request')
        end
      end
    end

    context 'when there is no todo with the specified id' do
      it 'responds with http 404' do
        put '/todos/42', params: { title: 'just do it' }, headers: headers
        expect(response).to have_http_status(:not_found)
      end

      it 'responds with an error' do
        put '/todos/42', params: { title: 'just do it' }, headers: headers
        response_body = JSON.parse(response.body)
        expect(response_body).to eql('error' => 'not found')
      end
    end
  end

  describe 'DELETE /todos/:id' do
    context 'when there is a todo with the specified id' do
      let!(:todo) { create(:todo) }

      it 'responds with http 204' do
        delete "/todos/#{todo.id}", headers: headers
        expect(response).to have_http_status(:no_content)
      end

      it 'deletes the todo' do
        expect { delete "/todos/#{todo.id}", headers: headers }.to change { Todo.exists?(todo.id) }.from(true).to(false)
      end
    end

    context 'when there is no todo with the specified id' do
      it 'responds with http 404' do
        delete '/todos/42', headers: headers
        expect(response).to have_http_status(:not_found)
      end

      it 'responds with an error' do
        delete '/todos/42', headers: headers
        response_body = JSON.parse(response.body)
        expect(response_body).to eql('error' => 'not found')
      end
    end
  end
end
