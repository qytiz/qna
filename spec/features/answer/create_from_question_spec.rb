# frozen_string_literal: true

require 'rails_helper'

feature 'user can create new answer from question page' do
  given(:question) { create(:question) }

  context 'User logined', js: true do
    given(:user) { create(:user) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario ' user can create new answer with valid data' do
      fill_in 'Title', with: 'Test answer'
      click_on 'Add new answer'

      expect(page).to have_content 'Test answer'
    end

    # scenario 'attach file' do
    #  fill_in 'Title', with: 'Test answer'
    #  attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
    #  click_on 'Add new answer'
    #  visit question_path(question)
    #  expect(page).to have_link 'rails_helper.rb'
    # end

    scenario ' user cant create new answer with invalid data' do
      click_on 'Add new answer'

      expect(page).to have_content "Title can't be blank"
    end
  end

  context 'User unlogined' do
    scenario ' user can create new answer with valid data' do
      visit question_path(question)
      fill_in 'Title', with: 'Test answer'
      click_on 'Add new answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
