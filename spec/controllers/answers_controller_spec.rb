require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) {create (:question)}
  describe 'Get #new' do
    before {get :new, params:{question_id:question}}

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      
      before { post :create, params: { question_id: question, answer: attributes_for(:answer) }}

      it 'save a new answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change { question.answers.count }.by(1)
      end

      it 'redirect to show view' do
        expect(response).to redirect_to [question, :answers]
      end
    end

    context 'with invalid attributes' do
      before { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }}

      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.not_to change(Answer, :count)
      end

      it 're-render new view' do
        expect(response).to render_template :new
      end
    end
  end
end
