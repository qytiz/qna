require 'rails_helper'

feature 'user can create new answer from question page' do
  given(:question){create(:question)}
  given(:user){create(:user)}
  before do 
    sign_in(user)
    visit question_path(question)
  end
  it ' user can create new answer' do
    fill_in 'Title', with: 'Test answer'
    click_on 'Add new answer'

    expect(page).to have_content 'New answer sucessfully created'
    expect(page).to have_content 'Test answer'
  end
end