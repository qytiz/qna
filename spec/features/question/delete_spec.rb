require 'rails_helper'

feature 'Only author user can delete questions and answers' do
  given(:user){create(:user)}
  before{sign_in(user)}

  it 'can delete question' do
    question=create(:question, user: user)
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content 'Question delited sucessfully'
  end

  it 'can delete answer' do
    question=create(:question, user: user)
    answer=create(:answer,question:question)
    visit question_answer_path(question,answer)
    click_on 'Delete answer'
    expect(page).to have_content 'Answer delited sucessfully'
  end

  it "Other users can't delete answer" do
    question=create(:question)
    answer=create(:answer,question:question)
    visit question_answer_path(question,answer)
    expect(page).to_not have_content 'Delete answer'
  end

  it "Other users can't delete question" do 
    question=create(:question)
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end
end