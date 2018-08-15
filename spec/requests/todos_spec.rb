require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  describe 'GET /todos' do
    subject { get todos_path }

    let!(:todos) { create_list(:todo, 2) }
    let(:expect_todo_result) do
      {
        'id' => todo.id,
        'title' => todo.title,
        'text' => todo.text,
        'created_at' => todo.created_at.in_time_zone.iso8601,
      }
    end

    it 'returns HTTP Status 200' do
      subject
      expect(response.status).to eq 200
    end

    context 'First todo' do
      let(:todo) { todos.first }

      it 'return valid JSON' do
        subject
        expect(JSON.parse(response.body)[0]).to eq expect_todo_result
      end
    end

    context 'Second todo' do
      let(:todo) { todos.second }

      it 'return valid JSON' do
        subject
        expect(JSON.parse(response.body)[1]).to eq expect_todo_result
      end
    end
  end
end
