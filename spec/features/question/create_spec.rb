# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question' do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'Asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question sucessfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'Asks a question with errors' do
      click_on 'Ask'
      expect(page).to have_content 'error(s) detected:'
    end

    scenario 'attach file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'
      expect(page).to have_link 'rails_helper.rb'
    end
  end

  context 'multiple sessions', js: true do
    scenario 'question appears at another user page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
        click_on 'Ask question'
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Ask'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end
    end
  end

  scenario 'Unauthentifacated user tries to asks a question' do
    visit questions_path
    expect(page).to_not have_link 'Ask question'
  end
end
