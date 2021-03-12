require 'rails_helper'

feature 'Only author user can delete questions and answers' do
  given(:user){create(:user)}
  context 'User logined' do
    before{sign_in(user)}
    context 'Author' do
      let!(:question) {create (:question),user:user}
      let!(:answer) {create (:answer), user:user,question:question}

      it 'can delete answer' do
        visit question_path(question)
        click_on 'Delete answer'
        expect(page).to have_content 'Answer delited sucessfully'
        expect(page).to_not have_content answer.title
      end
    end

    context 'Not author' do
      let!(:question){create(:question)}
      let!(:answer) {create (:answer),question:question}
      it "Other users can't delete answer" do 
        visit question_path(question)
        expect(page).to_not have_content 'Delete answer'
      end
    end
  end
  
  context 'User not logined' do
    let!(:question) {create (:question),user:user}
    let!(:answer) {create (:answer), user:user,question:question}
    it 'cant delete answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Delete answer'
    end
  end
end