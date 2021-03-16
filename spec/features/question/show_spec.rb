# frozen_string_literal: true

require 'rails_helper'

feature 'user can see list questions' do
  let!(:questions) { create_list(:question, 5) }

  scenario 'user can see list of all question' do
    visit questions_path
    questions.each do |q|
      expect(page).to have_content q.title
      expect(page).to have_content q.body
    end
  end
end
