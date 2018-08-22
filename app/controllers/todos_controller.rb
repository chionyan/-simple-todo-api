class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update]

  def index
    todos = Todo.all.order(:created_at)
    render json: todos
  end

  def create
    todo = Todo.create!(todo_params)
    render json: todo, status: :created, location: todo
  end

  def show
    render json: @todo
  end

  def update
    @todo.update!(todo_params)
    render json: @todo
  end

  private

  def set_todo
    @todo = Todo.find(params['id'])
  end

  def todo_params
    params.permit(:title, :text)
  end
end
