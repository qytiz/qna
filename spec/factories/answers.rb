FactoryBot.define do
  factory :answer do
    correct {false}
    sequence(:title) { |n| "Answer#{n}" }
    question
    trait :invalid do 
      title{nil}
    end
  end
end