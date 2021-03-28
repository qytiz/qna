# frozen_string_literal: true

require 'rails_helper'

feature 'User can add comment', js: true do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'question' do
      scenario 'create comment' do
        within ".new-comment-question-#{question.id}" do
          click_on 'Add comment'
          fill_in 'comment_body', with: 'test comment'
          click_on 'Comment'
        end
        within ".comments-question-#{question.id}" do
          expect(page).to have_content 'test comment'
        end
      end

      scenario "can't create comment with invalid data" do
        within ".new-comment-question-#{question.id}" do
          click_on 'Add comment'

          click_on 'Comment'
        end
        within ".comments-question-#{question.id}-errors" do
          expect(page).to have_content 'error(s) detected:'
        end
      end
    end

    context 'Answer' do
      scenario 'create comment' do
        within ".new-comment-answer-#{answer.id}" do
          click_on 'Add comment'
          fill_in 'comment_body', with: 'test comment'
          click_on 'Comment'
        end
        within ".comments-answer-#{answer.id}" do
          expect(page).to have_content 'test comment'
        end
      end

      scenario "can't create comment with invalid data" do
        within ".new-comment-answer-#{answer.id}" do
          click_on 'Add comment'

          click_on 'Comment'
        end
        within ".comments-answer-#{answer.id}-errors" do
          expect(page).to have_content 'error(s) detected:'
        end
      end
    end
  end

  context 'Unauthenticated user' do
    scenario "can't add new comment" do
      visit question_path(question)
      expect(page).to_not have_link 'Add comment'
    end
  end

  context 'multiple sessions', js: true do
    scenario 'comment appears at another user page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        click_on 'Add new answer'
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within ".new-comment-question-#{question.id}" do
          click_on 'Add comment'
          fill_in 'comment_body', with: 'test comment'
          click_on 'Comment'
        end
        within ".comments-question-#{question.id}" do
          expect(page).to have_content 'test comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'test comment'
      end
    end
  end
end
