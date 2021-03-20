require 'rails_helper'

feature 'User can add link to question' do
  given(:user){create(:user)}
  given(:url){'htttps://google.com'}

  scenario 'user adds link when ask question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text'

    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'My url', href: url
  end
end