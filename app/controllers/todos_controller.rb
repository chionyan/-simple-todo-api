class TodosController < ApplicationController
  def index
    todos = Todo.all.order(:created_at)
    render json: todos
  end

  def create
    todo = Todo.create!(todo_params)
    render json: todo, status: :created, location: todo
  end

  def show
    todo = Todo.find(params['id'])
    render json: todo
  end

  def update
    todo = Todo.find(params['id'])
    todo.update!(todo_params)
    render json: todo, location: todo
  end

  def destroy
    todo = Todo.find(params['id'])
    todo.destroy!
    render json: todo
  end

  private

  def todo_params
    params.permit(:title, :text)
  end
end
