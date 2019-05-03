# frozen_string_literal: true

class TodosController < ApplicationController
  API_KEY_HEADER = 'X_API_KEY'
  TOTAL_COUNT_HEADER = 'X_TOTAL_COUNT'
  DEFAULT_PAGE_SIZE = 20

  attr_reader :todo

  before_action :check_api_key
  before_action :fetch_todo, only: %i[show update destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_bad_request

  def index
    response.set_header(TOTAL_COUNT_HEADER, todos.except(:limit, :offset).count)
    render json: todos.page(page).per(per_page)
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

  def todos
    @todos ||= params.key?(:completed) ? Todo.where(completed: params[:completed]) : Todo.all
  end

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

  def page
    params[:page].to_i.abs
  end

  def per_page
    page_size = params[:page_size].to_i.abs
    page_size.zero? ? DEFAULT_PAGE_SIZE : page_size
  end

  def render_not_found
    render json: { error: 'not found' }, status: :not_found
  end

  def render_bad_request
    render json: { error: 'bad request' }, status: :bad_request
  end
end
