require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  before { travel_to '2019-01-01T00:00:00Z' }

  describe 'GET /todos' do
    subject { get '/todos' }

    let!(:todo_first) { create(:todo, title: 'Sample title 1', text: 'Sample text 1') }
    let!(:todo_second) { create(:todo, title: 'Sample title 2', text: 'Sample text 2') }

    it 'returns HTTP Status 200' do
      subject
      expect(response.status).to eq 200
    end

    it 'return valid JSON' do
      expect_todo_first = {
        'id' => todo_first.id,
        'title' => 'Sample title 1',
        'text' => 'Sample text 1',
        'created_at' => '2019-01-01T00:00:00Z',
      }

      expect_todo_second = {
        'id' => todo_second.id,
        'title' => 'Sample title 2',
        'text' => 'Sample text 2',
        'created_at' => '2019-01-01T00:00:00Z',
      }

      subject
      result_todos = JSON.parse(response.body)

      aggregate_failures do
        expect(result_todos.count).to eq 2
        expect(result_todos[0]).to eq expect_todo_first
        expect(result_todos[1]).to eq expect_todo_second
      end
    end
  end

  describe 'POST /todos' do
    subject { post '/todos', params: params }

    let(:params) { { title: 'Sample title', text: 'Sample text' } }

    it 'returns HTTP Status 201' do
      subject
      expect(response.status).to eq 201
    end

    it 'returns input params' do
      subject
      result_todo = JSON.parse(response.body)

      aggregate_failures do
        expect(result_todo['id']).to_not be_empty
        expect(result_todo['title']).to eq 'Sample title'
        expect(result_todo['text']).to eq 'Sample text'
        expect(result_todo['created_at']).to_not be_empty
      end
    end

    it 'create 1 todo' do
      expect { subject }.to change(Todo, :count).by(1)
    end
  end

  describe 'GET /todos/{todo_id}' do
    subject { get "/todos/#{todo.id}" }

    let!(:todo) { create(:todo, title: 'Sample title', text: 'Sample text') }

    it 'returns HTTP Status 200' do
      subject
      expect(response.status).to eq 200
    end

    it 'return valid JSON' do
      expect_todo = {
        'id' => todo.id,
        'title' => 'Sample title',
        'text' => 'Sample text',
        'created_at' => '2019-01-01T00:00:00Z',
      }

      subject
      result_todo = JSON.parse(response.body)

      expect(result_todo).to eq expect_todo
    end
  end
end
