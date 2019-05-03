# frozen_string_literal: true

class TodosController < ApplicationController
  def index
    todos = Todo.all
    render json: todos
  end

  def show
    todo = Todo.find(params[:id])
    render json: todo
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'not found' }, status: :not_found
  end

  def create
    todo = Todo.create!(todo_params)
    render json: todo, status: :created
  rescue ActiveRecord::RecordInvalid
    render json: { error: 'bad request' }, status: :bad_request
  end

  def update
    todo = Todo.find(params[:id])
    todo.update!(todo_params)
    render json: todo
  rescue ActiveRecord::RecordInvalid
    render json: { error: 'bad request' }, status: :bad_request
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'not found' }, status: :not_found
  end

  def destroy
    todo = Todo.find(params[:id])
    todo.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'not found' }, status: :not_found
  end

  private

  def todo_params
    params.permit(:title, :completed)
  end
end
