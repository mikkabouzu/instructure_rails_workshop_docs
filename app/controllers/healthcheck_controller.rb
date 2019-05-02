# frozen_string_literal: true

class HealthcheckController < ApplicationController
  def index
    render json: { success: true }
  end
end
