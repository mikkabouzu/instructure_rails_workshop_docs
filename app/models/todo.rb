# frozen_string_literal: true

class Todo < ApplicationRecord
  validates :title, presence: true
  before_validation :handle_completed_at

  private

  def handle_completed_at
    if completed?
      self.completed_at ||= Time.zone.now
    else
      self.completed_at = nil
    end
  end
end
