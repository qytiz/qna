# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up' do
  background { visit new_user_registration_path }

  scenario 'User sign up with right data' do
    fill_in 'Email', with: 'unicle@email.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
  scenario 'User sign up with wrong data' do
    fill_in 'Email', with: 'wrong'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'

    click_on 'Sign up'

    expect(page).to have_content 'error prohibited this user from being saved:'
  end
end
