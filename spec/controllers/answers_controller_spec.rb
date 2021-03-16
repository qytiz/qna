# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'User logined' do
      before { sign_in(user) }

      context 'with valid attributes' do
        before { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

        it 'save a new answer to database' do
          expect do
            post :create, params: { question_id: question, answer: attributes_for(:answer) } 
          end.to change {question.answers.count}.by(1)
        end

        it 'redirect to show view' do
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        before { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

        it 'does not save the question' do
          expect do
            post :create,
                 params: { question_id: question, answer: attributes_for(:answer, :invalid) }
          end.not_to change(Answer, :count)
        end

        it 're-render new view' do
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'User unlogined' do
      it 'not save a new answer to database' do
        expect do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        end.to_not change {question.answers.count}
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author'
    before { login(user) }
    let!(:answer) { create :answer, question: question, user: user }

    it 'deletes the answer' do
      expect do
        delete :destroy, params: { id: answer, user: user, question: question }
      end.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer,question_id:question }
      expect(response).to redirect_to questions_path
    end
  end
  context 'Not author' do
    let!(:answer) { create :answer, question: question }
    before { login(user) }

    it 'not deletes the answer' do
      expect do
        delete :destroy, params: { id: answer, question: question }
      end.to_not change(Answer, :count)
    end
    
    it 'redirect to index' do
        delete :destroy, params: { id: answer, question: question }
        expect(response).to redirect_to questions_path
    end
  end
end
