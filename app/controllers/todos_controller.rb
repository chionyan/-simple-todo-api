class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    errors = [
      {
        title: i18n_errors_messages('not_found'),
        status: 404,
      },
    ]
    render json: { errors: errors }, status: 404
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    errors = e.record.errors.messages.keys
    errors.map! do |attribute|
      {
        title: i18n_todo_attribute(attribute) + i18n_errors_messages('invalid'),
        status: 422,
        source: { pointer: "/#{attribute}" },
      }
    end
    render json: { errors: errors }, status: 422
  end

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

  def destroy
    @todo.destroy!
    render json: @todo
  end

  private

  def set_todo
    @todo = Todo.find(params['id'])
  end

  def todo_params
    params.permit(:title, :text)
  end

  def i18n_todo_attribute(attribute_name)
    I18n.t(attribute_name, scope: 'activerecord.attributes.todo', locale: 'ja')
  end

  def i18n_errors_messages(error_name)
    I18n.t(error_name, scope: 'errors.messages', locale: 'ja')
  end
end
