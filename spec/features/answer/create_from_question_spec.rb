require 'rails_helper'

feature 'user can create new answer from question page' do
  given(:question){create(:question)}
  context 'User logined' do
    given(:user){create(:user)}
    before do 
      sign_in(user)
      visit question_path(question)
    end
    
    it ' user can create new answer with valid data' do
      fill_in 'Title', with: 'Test answer'
      click_on 'Add new answer'

      expect(page).to have_content 'New answer sucessfully created'
      expect(page).to have_content 'Test answer'
    end

    it ' user cant create new answer with invalid data' do

      click_on 'Add new answer'

      expect(page).to_not have_content 'New answer sucessfully created'
    end
  end
  
  context 'User unlogined' do
    it ' user can create new answer with valid data' do
      visit question_path(question)
      fill_in 'Title', with: 'Test answer'
      click_on 'Add new answer'
  
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end