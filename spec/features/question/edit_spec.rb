# frozen_string_literal: true

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

  context 'edit with atttachments', js: true do
    before do
      sign_in(user)
      visit questions_path
      within(".question-id-#{question.id}") do
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
      within(".question-id-#{question.id}") do
        within("#file-#{question.files.first.id}") { click_on 'Delete' }
        expect(page).to_not have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'tries to delete others question files' do
      click_on 'logout'
      sign_in(create(:user))
      within first(".question-id-#{question.id}") { expect(page).to_not have_link 'Delete' }
    end
  end

  context 'with links', js: true do
    before do
      sign_in(user)
      question.links.build(linkable: question, name: 'google', url: 'http://google.com')
      question.save
      visit questions_path
    end

    scenario 'with deleting links' do
      click_button 'Delete link'

      expect(page).to_not have_link 'google'
    end

    scenario 'with adding another link' do
      click_on 'Edit'

      click_on 'add link'
      fill_in 'Link name', with: 'google 2'
      fill_in 'Url', with: 'https://www.google.com/maps/'

      click_on 'Save'

      expect(page).to have_link 'google'
      expect(page).to have_link 'google 2'
    end

    scenario 'user try to delete someone else link' do
      click_on 'logout'
      sign_in(create(:user))

      expect(page).to_not have_button 'Delete link'
    end
  end
end
