require 'rails_helper'

feature 'user can give awards' do
  given(:user) { create(:user) }
  before { sign_in(user) }
  
  scenario 'Author set new award for question' do
  click_on 'Ask question'
  fill_in 'Title', with: 'Test question'
  fill_in 'Body', with: 'text text text'
  
  within '.award' do
  fill_in 'Award title', with: 'test title'
  attach_file 'Image',  "#{Rails.root}/app/assets/images/1.png"
  end
  click_on 'Ask'
  within '.award' do
  expect(page).to have_content 'test title'
  end


  end

end