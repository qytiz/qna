# frozen_string_literal: true

require 'rails_helper'

feature 'User can add link to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:url) { 'htttps://google.com' }

  scenario 'user adds link when ask answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Title', with: 'Test answer'

    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: url

    click_on 'Add new answer'
    visit question_path(question)
    within '.answers' do
      expect(page).to have_link 'My url', href: url
    end
  end
end
