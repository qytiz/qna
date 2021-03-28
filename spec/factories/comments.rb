# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { 'test comment' }
    user { nil }
    commentable { nil }
    trait :invalid do
      body { nil }
    end
  end
end
