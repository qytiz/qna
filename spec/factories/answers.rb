FactoryBot.define do
  factory :answer do
    title { "MyString" }
    correct? {false}
    question {nil}
    trait :invalid do 
      title{nil}
    end
  end
end