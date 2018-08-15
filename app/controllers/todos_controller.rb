class TodosController < ApplicationController
  def index
    todos = Todo.all.order(:created_at)
    render json: todos
  end
end
