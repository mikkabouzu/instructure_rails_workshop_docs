# frozen_string_literal: true

class TodosController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_bad_request

  def index
    todos = Todo.all
    render json: todos
  end

  def show
    todo = Todo.find(params[:id])
    render json: todo
  end

  def create
    todo = Todo.create!(todo_params)
    render json: todo, status: :created
  end

  def update
    todo = Todo.find(params[:id])
    todo.update!(todo_params)
    render json: todo
  end

  def destroy
    todo = Todo.find(params[:id])
    todo.destroy!
    head :no_content
  end

  private

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
