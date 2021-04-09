# frozen_string_literal: true

require 'rails_helper'
require 'rails_helper'

feature 'User can subscribe to question' do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'authenticated user' do
    context 'author' do
      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario 'author can subscribe and unsubscribe' do
        click_on 'Unsubscribe'
        expect(page).to_not have_link 'Unsubscribe'
        expect(page).to have_link 'Subscribe'

        click_on 'Subscribe'

        expect(page).to have_link 'Unsubscribe'
        expect(page).to_not have_link 'Subscribe'
      end
    end

    context 'not author' do
      background do
        sign_in(other_user)

        visit question_path(question)
      end

      scenario 'can subscribe' do
        click_on 'Subscribe'

        expect(page).to have_link 'Unsubscribe'
        expect(page).to_not have_link 'Subscribe'
      end

      scenario 'can unsubscribe' do
        click_on 'Subscribe'
        click_on 'Unsubscribe'

        expect(page).to_not have_link 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
      end
    end
  end

  describe 'unautheticated user' do
    it "can't subscribe for question" do
      visit question_path(question)

      expect(page).to_not have_link 'Unsubscribe'
      expect(page).to_not have_link 'Subscribe'
    end
  end
end
