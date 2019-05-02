# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'healthcheck' do
  it 'responds with http 200' do
    get '/healthcheck'
    expect(response).to have_http_status(:ok)
  end

  it 'responds with {success: true}' do
    get '/healthcheck'
    response_body = JSON.parse(response.body)
    expect(response_body).to eql('success' => true)
  end
end
