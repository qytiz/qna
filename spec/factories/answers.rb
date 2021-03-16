# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    sequence(:title) { |n| "Answer#{n}" }
    question
    user
    trait :invalid do
      title { nil }
    end
  end
end
