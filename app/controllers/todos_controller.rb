# frozen_string_literal: true

class TodosController < ApplicationController
  def show
    todo = Todo.find(params[:id])
    render json: todo
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
end
