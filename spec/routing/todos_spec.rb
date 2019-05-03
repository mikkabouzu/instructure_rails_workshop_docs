# frozen_string_literal: true

RSpec.describe 'todos' do
  it 'GET todos/:id is routed to todos#show' do
    expect(get: '/todos/42').to route_to(controller: 'todos', action: 'show', id: '42')
  end

  it 'DELETE todos/:id is routed to todos#destroy' do
    expect(delete: '/todos/42').to route_to(controller: 'todos', action: 'destroy', id: '42')
  end
end
