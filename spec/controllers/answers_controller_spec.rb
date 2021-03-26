# frozen_string_literal: true

require './spec/controllers/voted_controller_spec'
require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  include_examples 'voted controller'
  describe 'POST #create' do
    context 'User logined' do
      before { sign_in(user) }

      context 'with valid attributes' do
        before { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :json }

        it 'save a new answer to database' do
          expect do
            post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :json
          end.to change { question.answers.count }.by(1)
        end
      end

      context 'with invalid attributes' do
        before do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :json
        end

        it 'does not save the question' do
          expect do
            post :create,
                 params: { question_id: question, answer: attributes_for(:answer, :invalid) },
                 format: :json
          end.not_to change(Answer, :count)
        end
      end
    end

    context 'User unlogined' do
      it 'not save a new answer to database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        end.to_not change { question.answers.count }
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author'
    before { login(user) }
    let!(:answer) { create :answer, question: question, user: user }

    it 'deletes the answer' do
      expect do
        delete :destroy, params: { id: answer, user: user, question: question }, format: :js
      end.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer, question_id: question }, format: :js
      expect(response).to render_template :destroy
    end
  end
  context 'Not author' do
    let!(:answer) { create :answer, question: question }
    before { login(user) }

    it 'not deletes the answer' do
      expect do
        delete :destroy, params: { id: answer, question: question }, format: :js
      end.to_not change(Answer, :count)
    end

    it 'redirect to index' do
      delete :destroy, params: { id: answer, question: question }, format: :js
      expect(response).to render_template :destroy
    end
  end
  describe 'PATCH #update' do
    let!(:answer) { create :answer, question: question, user: user }

    context 'User unlogined' do
      it 'not change answer' do
        patch :update, params: { id: answer, answer: { title: 'new body' } }, format: :js
        answer.reload
        expect(answer.title).to_not eq 'new body'
      end
    end

    context 'User logined' do
      before { login(user) }

      context 'with valid_atrtributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { title: 'new body' } }, format: :js
          answer.reload
          expect(answer.title).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { title: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :json
        end

        it 'does not save the answer' do
          expect do
            post :create,
                 params: { question_id: question, answer: attributes_for(:answer, :invalid) },
                 format: :json
          end.not_to change(answer, :title)
        end
      end

      context 'User not change other user answer' do
        it 'does not change other user question' do
          user = create(:user)
          login(user)
          patch :update, params: { id: answer, answer: { title: 'new body' } }, format: :js
          answer.reload
          expect(answer.title).to_not eq 'new body'
        end
      end
    end
  end

  describe 'POST #mark_best' do
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    before { login(user) }

    it 'Mark answer as best' do
      post :mark_best, params: { id: answer.id }, format: :js
      expect { answer.reload }.to change(answer, :best_answer)
    end
  end
end
