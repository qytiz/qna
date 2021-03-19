require 'rails_helper'

feature 'User can edit question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  scenario 'Unauthenticated user not edit question' do
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)

      click_on 'Edit'
    end

    scenario 'edit his answer' do
      within '.questions' do
        fill_in 'question_title', with: 'edited title'
        fill_in 'question_body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit with errors' do
      within '.questions' do
        fill_in 'question_title', with: ''
        click_on 'Save'
      end
      expect(page).to have_content 'error(s) detected:'
    end
  end

  scenario 'tries to edit other user question' do
    new_user = create(:user)
    sign_in(new_user)
    expect(page).to_not have_content 'Edit'
  end
end
