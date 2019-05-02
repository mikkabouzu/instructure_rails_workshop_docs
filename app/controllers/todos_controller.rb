# frozen_string_literal: true

class TodosController < ApplicationController
  def show
    todo = Todo.find(params[:id])
    render json: todo
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'not found' }, status: :not_found
  end
end
