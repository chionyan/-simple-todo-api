class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    errors = [{ title: I18n.t('errors.messages.not_found', locale: 'ja'), status: 404 }]
    render json: { errors: errors }, status: 404
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    pointers = []
    e.record.errors.messages.keys.each do |attribute|
      pointers << "/data/attributes/#{attribute}"
    end
    errors = [{ title: I18n.t('errors.messages.invalid', locale: 'ja'), status: 422, source: { 'pointer' => pointers } }]
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
end
