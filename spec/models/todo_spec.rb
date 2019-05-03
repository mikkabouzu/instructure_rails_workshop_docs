# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Todo, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'completed_at' do
    context 'mark a todo completed' do
      context 'todo is completed' do
        subject { build(:todo, :completed) }

        it 'will not change completed_at' do
          expect { subject.update(completed: true) }.not_to(change { subject.completed_at })
        end
      end

      context 'todo is uncompleted' do
        subject { build(:todo, :uncompleted) }

        it 'will set completed_at to now' do
          freeze_time do
            expect { subject.update(completed: true) }.to change { subject.completed_at }.to(Time.current)
          end
        end
      end
    end

    context 'mark a todo uncompleted' do
      context 'todo is completed' do
        subject { build(:todo, :completed) }

        it 'will set completed_at to nil' do
          expect { subject.update(completed: false) }.to change { subject.completed_at }.to(nil)
        end
      end

      context 'todo is uncompleted' do
        subject { build(:todo, :uncompleted) }

        it 'will not change completed_at' do
          expect { subject.update(completed: false) }.not_to(change { subject.completed_at })
        end
      end
    end
  end
end
