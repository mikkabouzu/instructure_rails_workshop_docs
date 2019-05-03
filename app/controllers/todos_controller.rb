# frozen_string_literal: true

class TodosController < ApplicationController
  API_KEY_HEADER = 'X_API_KEY'
  attr_reader :todo

  before_action :check_api_key
  before_action :fetch_todo, only: %i[show update destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_bad_request

  def index
    todos = Todo.all
    render json: todos
  end

  def show
    render json: todo
  end

  def create
    new_todo = Todo.create!(todo_params)
    render json: new_todo, status: :created
  end

  def update
    todo.update!(todo_params)
    render json: todo
  end

  def destroy
    todo.destroy!
    head :no_content
  end

  private

  def check_api_key
    return if request.headers[API_KEY_HEADER] == Rails.configuration.api_key

    head :unauthorized
  end

  def fetch_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.permit(:title, :completed)
  end

  def render_not_found
    render json: { error: 'not found' }, status: :not_found
  end

  def render_bad_request
    render json: { error: 'bad request' }, status: :bad_request
  end
end
