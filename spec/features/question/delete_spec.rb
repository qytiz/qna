# frozen_string_literal: true

require 'rails_helper'

feature 'Only author user can delete questions' do
  given(:user) { create(:user) }
  before { sign_in(user) }

  context 'Author' do
    let(:question) { create :question, user: user }

    scenario 'can delete question' do
      visit question_path(question)
      click_on 'Delete question'
      expect(page).to have_content 'Question delited sucessfully'
      expect(page).to_not have_content question.title
    end
  end

  context 'Not author' do
    let(:question) { create(:question) }

    scenario "Other users can't delete question" do
      visit question_path(question)
      expect(page).to_not have_content 'Delete question'
    end
  end
end
