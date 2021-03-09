require 'rails_helper'

feature 'user can see list questions' do
  it 'user can see list of all question' do
    question=create(:question)
    visit questions_path
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end