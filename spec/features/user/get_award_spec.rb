require 'rails_helper'

feature 'user can have awards' do
  given(:user) { create(:user) }
  before { sign_in(user) }
  
  scenario 'User get new award for question', js:true do
  click_on 'Ask question'
  fill_in 'Title', with: 'Test question'
  fill_in 'Body', with: 'text text text'
  
  within '.award' do
  fill_in 'Award title', with: 'test title'
  attach_file 'Image',  "#{Rails.root}/app/assets/images/1.png"
  end
  click_on 'Ask'

  fill_in 'Title', with: 'Test answer'
  click_on 'Add new answer'
  click_on 'Mark as best'
  click_on 'Your rewards'
  
  expect(page).to have_content 'test title'

  end

end