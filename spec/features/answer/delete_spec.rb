# frozen_string_literal: true

require 'rails_helper'

feature 'Only author user can delete answers' do
  given(:user) { create(:user) }

  context 'User logined' do
    before { sign_in(user) }

    context 'Author' do
      let!(:question) { create :question, user: user }
      let!(:answer) { create :answer, user: user, question: question }

      scenario 'can delete answer' do
        visit question_path(question)
        expect(page).to have_content answer.title
        click_on 'Delete answer'
        expect(page).to have_content 'Answer delited sucessfully'
        expect(page).to_not have_content answer.title
      end
    end

    context 'Not author' do
      let!(:question) { create(:question) }
      let!(:answer) { create :answer, question: question }

      scenario "Other users can't delete answer" do
        visit question_path(question)
        expect(page).to_not have_content 'Delete answer'
      end
    end
  end

  context 'User not logined' do
    let!(:question) { create :question, user: user }
    let!(:answer) { create :answer, user: user, question: question }

    scenario 'cant delete answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Delete answer'
    end
  end
end
