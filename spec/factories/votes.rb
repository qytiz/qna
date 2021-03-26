# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    score { 1 }
    user { nil }
    votable { nil }
  end
end
