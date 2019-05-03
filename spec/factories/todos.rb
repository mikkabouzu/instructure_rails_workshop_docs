# frozen_string_literal: true

FactoryBot.define do
  factory :todo do
    title { 'MyString' }
    completed { false }

    trait :completed do
      completed { true }
      completed_at { '2019-05-03 00:36:38' }
    end

    trait :uncompleted do
      completed { false }
      completed_at { nil }
    end
  end
end
