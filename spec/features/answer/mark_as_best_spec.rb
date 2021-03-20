# frozen_string_literal: true

require 'rails_helper'

feature 'Question author can mark  answer as best', js: true do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'unauthenticated user not mark answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Mark as best'
  end

  describe 'Authinticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'author mark answer as best' do
      click_on 'Mark as best'
      expect(page).to_not have_link 'Mark as best'
    end
  end

  scenario 'user not mark answer in other user question' do
    user = create(:user)
    sign_in(user)
    expect(page).to_not have_link 'Mark as best'
  end
end
