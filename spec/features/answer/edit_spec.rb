# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit answer' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  scenario 'Unauthenticated user not edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'
    end

    scenario 'edit his answer' do
      within '.answers' do
        fill_in 'answer_title', with: 'edited anwer'
        click_on 'Save'

        expect(page).to_not have_content answer.title
        expect(page).to have_content 'edited anwer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit with errors' do
      within '.answers' do
        fill_in 'answer_title', with: ''
        click_on 'Save'
      end
      expect(page).to have_content 'error(s) detected:'
    end
  end

  scenario 'tries to edit other user question' do
    new_user = create(:user)
    sign_in(new_user)
    visit question_path(question)
    expect(page).to_not have_content 'Edit'
  end

  context 'edit with atttachments', js: true do
    before do
      sign_in(user)
      visit question_path(question)
      within(".answer-id-#{answer.id}") do
        click_on 'Edit'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end
    end

    scenario 'files added' do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'delete files' do
      within(".answer-id-#{answer.id}") do
        within("#file-#{answer.files.first.id}") { click_on 'Delete' }
        expect(page).to_not have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'tries to delete others question files' do
      click_on 'logout'
      sign_in(create(:user))
      visit question_path(question)
      within first(".answer-id-#{answer.id}") { expect(page).to_not have_link 'Delete' }
    end
  end
end
