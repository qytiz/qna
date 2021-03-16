# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in' do
  given(:user) { create(:user) }
  background { visit root_path }

  scenario 'User sign out' do
    sign_in(user)
    click_on 'logout'

    expect(page).to have_content 'Signed out successfully'
  end
end
