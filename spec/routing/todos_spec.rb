# frozen_string_literal: true

RSpec.describe 'todos' do
  it 'GET todos/:id is routed to todos#show' do
    expect(get: '/todos/42').to route_to(controller: 'todos', action: 'show', id: '42')
  end
end
