# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'MyString' }
    url { 'https://www.google.com/' }
    linkable {nil}
  end
end
