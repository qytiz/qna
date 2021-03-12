require 'rails_helper'

feature 'User can view question and answers belong to it'do 
  given(:question) { create(:question) }
  given(:answers){create_list(:answer,5,question:question)}
  
  scenario 'User view question with list of answers' do
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end