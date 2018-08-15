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
      expect(JSON.parse(response.body)[0]).to eq expect_todo_first
      expect(JSON.parse(response.body)[1]).to eq expect_todo_second
    end

    it 'return 2 JSON' do
      subject
      expect(JSON.parse(response.body).count).to eq 2
    end
  end
end
