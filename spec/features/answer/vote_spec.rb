# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for the answer' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: create(:user)) }

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'can upvote' do
      within "#answer-#{answer.id}-vote" do
        click_on 'upvote'
        expect(page.find('.total-score')).to have_content '1'
        visit question_path(question)
        expect(page.find('.total-score')).to have_content '1'
      end
    end

    scenario 'can downvote' do
      within "#answer-#{answer.id}-vote" do
        click_on 'downvote'
        expect(page.find('.total-score')).to have_content '-1'
        visit question_path(question)
        expect(page.find('.total-score')).to have_content '-1'
      end
    end

    scenario "can't own question" do
      answer = create(:answer, user: user, question: question)
      visit question_path(question)
      within "#answer-#{answer.id}-vote" do
        expect(page).to_not have_link 'upvote'
        expect(page).to_not have_link 'downvote'
      end
    end

    scenario "can't vote twice" do
      within "#answer-#{answer.id}-vote" do
        click_on 'upvote'
        click_on 'upvote'
      end
      expect(page).to have_content 'No double votes!'
    end

    scenario 'can see total score' do
      create_list(:vote, 5, user: create(:user), score: 1, votable: answer)
      visit question_path(question)
      within "#answer-#{answer.id}-vote" do
        expect(page.find('.total-score')).to have_content '5'
        visit question_path(question)
        expect(page.find('.total-score')).to have_content '5'
      end
    end

    scenario 'change vote' do
      within "#answer-#{answer.id}-vote" do
        click_on 'down'
        click_on 'upvote'
        click_on 'upvote'
        expect(page.find('.total-score')).to have_content '1'
        visit question_path(question)
        expect(page.find('.total-score')).to have_content '1'
      end
    end
  end

  scenario 'Unauthenticated user can not vote for the answer' do
    visit question_path(question)
    expect(page).to_not have_link 'upvote'
    expect(page).to_not have_link 'downvote'
  end
end
