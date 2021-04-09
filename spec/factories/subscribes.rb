# frozen_string_literal: true

FactoryBot.define do
  factory :subscribe do
    question
    user
    trait :unlogined do
      user { nil }
    end
  end
end
