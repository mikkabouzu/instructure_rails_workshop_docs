# frozen_string_literal: true

RSpec.describe 'healthcheck' do
  it 'is routed to /' do
    expect(get: '/').to route_to(controller: 'healthcheck', action: 'index')
  end

  it 'is routed to /healthcheck' do
    expect(get: '/healthcheck').to route_to(controller: 'healthcheck', action: 'index')
  end
end
