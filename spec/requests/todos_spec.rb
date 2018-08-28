require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  describe 'GET /todos' do
    subject { get '/todos' }

    before { travel_to '2019-01-01T00:00:00Z' }

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

    context 'Valid params' do
      let(:params) { { title: 'Sample title', text: 'Sample text' } }

      it 'returns HTTP Status 201' do
        subject
        aggregate_failures do
          expect(response.status).to eq 201
          expect(response.location).to eq "http://www.example.com/todos/#{Todo.last.id}"
        end
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

    context 'Invalid params' do
      context 'Empty title & text' do
        let(:params) { { title: '', text: '' } }

        it 'returns HTTP Status 422' do
          subject
          expect(response.status).to eq 422
        end

        it 'returns error JSON' do
          expect_errors = {
            'errors' => [
              {
                'title' => 'タイトルのバリデーションに失敗しました。',
                'status' => 422,
                'source' => { 'pointer' => '/title' },
              },
              {
                'title' => 'テキストのバリデーションに失敗しました。',
                'status' => 422,
                'source' => { 'pointer' => '/text' },
              },
            ],
          }

          subject
          result_errors = JSON.parse(response.body)
          expect(result_errors).to eq expect_errors
        end

        it 'not create todo' do
          expect { subject }.to_not change(Todo, :count)
        end
      end

      context 'Empty title' do
        let(:params) { { title: '', text: 'Sample text' } }

        it 'returns HTTP Status 422' do
          subject
          expect(response.status).to eq 422
        end

        it 'returns error JSON' do
          expect_errors = {
            'errors' => [
              {
                'title' => 'タイトルのバリデーションに失敗しました。',
                'status' => 422,
                'source' => { 'pointer' => '/title' },
              },
            ],
          }

          subject
          result_errors = JSON.parse(response.body)
          expect(result_errors).to eq expect_errors
        end

        it 'not create todo' do
          expect { subject }.to_not change(Todo, :count)
        end
      end

      context 'Empty text' do
        let(:params) { { title: 'Sample text', text: '' } }

        it 'returns HTTP Status 422' do
          subject
          expect(response.status).to eq 422
        end

        it 'returns error JSON' do
          expect_errors = {
            'errors' => [
              {
                'title' => 'テキストのバリデーションに失敗しました。',
                'status' => 422,
                'source' => { 'pointer' => '/text' },
              },
            ],
          }

          subject
          result_errors = JSON.parse(response.body)
          expect(result_errors).to eq expect_errors
        end

        it 'not create todo' do
          expect { subject }.to_not change(Todo, :count)
        end
      end
    end
  end

  describe 'GET /todos/:id' do
    before { travel_to '2019-01-01T00:00:00Z' }

    let!(:todo) { create(:todo, title: 'Sample title', text: 'Sample text') }

    context 'Exist Record' do
      subject { get "/todos/#{todo.id}" }

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

    context 'Not Exist Record' do
      subject { get '/todos/0' }

      it 'returns HTTP Status 404' do
        subject
        expect(response.status).to eq 404
      end

      it 'returns error JSON' do
        expect_errors = {
          'errors' => [
            {
              'title' => '見つかりませんでした。',
              'status' => 404,
            },
          ],
        }

        subject
        result_errors = JSON.parse(response.body)
        expect(result_errors).to eq expect_errors
      end
    end
  end

  describe 'PATCH /todos/:id' do
    before { travel_to '2019-01-01T00:00:00Z' }

    let!(:todo) { create(:todo, title: 'Sample title', text: 'Sample text') }
    let(:params) { { title: 'Change title', text: 'Change text' } }

    context 'Exist Record' do
      subject { patch "/todos/#{todo.id}", params: params }

      context 'Valid params' do
        it 'returns HTTP Status 200' do
          subject
          expect(response.status).to eq 200
        end

        it 'returns update JSON' do
          expect_todo = {
            'id' => todo.id,
            'title' => 'Change title',
            'text' => 'Change text',
            'created_at' => '2019-01-01T00:00:00Z',
          }

          subject
          result_todo = JSON.parse(response.body)
          expect(result_todo).to eq expect_todo
        end
      end

      context 'Invalid params' do
        context 'Empty title & text' do
          let(:params) { { title: '', text: '' } }

          it 'returns HTTP Status 422' do
            subject
            expect(response.status).to eq 422
          end

          it 'returns error JSON' do
            expect_errors = {
              'errors' => [
                {
                  'title' => 'タイトルのバリデーションに失敗しました。',
                  'status' => 422,
                  'source' => { 'pointer' => '/title' },
                },
                {
                  'title' => 'テキストのバリデーションに失敗しました。',
                  'status' => 422,
                  'source' => { 'pointer' => '/text' },
                },
              ],
            }

            subject
            result_errors = JSON.parse(response.body)
            expect(result_errors).to eq expect_errors
          end

          it 'not change params' do
            subject
            aggregate_failures do
              expect(todo.title).to eq 'Sample title'
              expect(todo.text).to eq 'Sample text'
            end
          end
        end

        context 'Empty title' do
          let(:params) { { title: '', text: 'Sample text' } }

          it 'returns HTTP Status 422' do
            subject
            expect(response.status).to eq 422
          end

          it 'returns error JSON' do
            expect_errors = {
              'errors' => [
                {
                  'title' => 'タイトルのバリデーションに失敗しました。',
                  'status' => 422,
                  'source' => { 'pointer' => '/title' },
                },
              ],
            }

            subject
            result_errors = JSON.parse(response.body)
            expect(result_errors).to eq expect_errors
          end

          it 'not change params' do
            subject
            aggregate_failures do
              expect(todo.title).to eq 'Sample title'
              expect(todo.text).to eq 'Sample text'
            end
          end
        end

        context 'Empty text' do
          let(:params) { { title: 'Sample text', text: '' } }

          it 'returns HTTP Status 422' do
            subject
            expect(response.status).to eq 422
          end

          it 'returns error JSON' do
            expect_errors = {
              'errors' => [
                {
                  'title' => 'テキストのバリデーションに失敗しました。',
                  'status' => 422,
                  'source' => { 'pointer' => '/text' },
                },
              ],
            }

            subject
            result_errors = JSON.parse(response.body)
            expect(result_errors).to eq expect_errors
          end

          it 'not change params' do
            subject
            aggregate_failures do
              expect(todo.title).to eq 'Sample title'
              expect(todo.text).to eq 'Sample text'
            end
          end
        end
      end
    end

    context 'Not Exist Record' do
      subject { patch '/todos/0', params: params }

      it 'returns HTTP Status 404' do
        subject
        expect(response.status).to eq 404
      end

      it 'returns error JSON' do
        expect_errors = {
          'errors' => [
            {
              'title' => '見つかりませんでした。',
              'status' => 404,
            },
          ],
        }

        subject
        result_errors = JSON.parse(response.body)
        expect(result_errors).to eq expect_errors
      end
    end
  end

  describe 'DELETE /todos/:id' do
    before { travel_to '2019-01-01T00:00:00Z' }

    let!(:todo) { create(:todo, title: 'Sample title', text: 'Sample text') }

    context 'Exist Record' do
      subject { delete "/todos/#{todo.id}" }

      it 'returns HTTP Status 200' do
        subject
        expect(response.status).to eq 200
      end

      it 'returns delete JSON' do
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

      it 'delete 1 todo' do
        expect { subject }.to change(Todo, :count).by(-1)
      end
    end

    context 'Not Exist Record' do
      subject { delete '/todos/0' }

      it 'returns HTTP Status 404' do
        subject
        expect(response.status).to eq 404
      end

      it 'returns error JSON' do
        expect_errors = {
          'errors' => [
            {
              'title' => '見つかりませんでした。',
              'status' => 404,
            },
          ],
        }

        subject
        result_errors = JSON.parse(response.body)
        expect(result_errors).to eq expect_errors
      end

      it 'not delete todo' do
        expect { subject }.to_not change(Todo, :count)
      end
    end
  end
end
