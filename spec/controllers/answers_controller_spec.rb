require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) {create (:question)}
  let(:user) {create (:user)}
  describe 'Get #new' do
    it 'render new view for logined user' do
      sign_in(user)
      get :new, params:{question_id:question}
      expect(response).to render_template :new
    end
    it 'Not render new view for unlogined user' do
      get :new, params:{question_id:question}
      expect(response).to_not render_template :new
    end
  end

  describe 'POST #create' do
    context 'User logined' do
      before{sign_in(user)}
      context 'with valid attributes' do
        before { post :create, params: { question_id: question, answer: attributes_for(:answer) }}
        it 'save a new answer to database' do
          expect { post :create, params: { question_id: question,  answer: attributes_for(:answer) } }.to change { question.answers.count }.by(1)
        end

        it 'redirect to show view' do
          expect(response).to redirect_to answer_path(question.answers.last)
        end
      end

      context 'with invalid attributes' do
        before { post :create, params: { question_id: question,   answer: attributes_for(:answer, :invalid) }}

        it 'does not save the question' do
          expect { post :create, params: { question_id: question,   answer: attributes_for(:answer, :invalid) } }.not_to change(Answer, :count)
        end

        it 're-render new view' do
          expect(response).to render_template 'questions/_question'
        end
      end
    end
    context "User unlogined" do
      it 'not save a new answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to_not change { question.answers.count }
      end
    end
  end
  describe 'DELETE #destroy' do
    before{login(user)}
    let!(:answer) {create (:answer),question:question,user:user}
    it 'deletes the question'do
    expect{delete :destroy, params:{id: answer,user:user,question:question}}.to change(Answer,:count).by(-1)
    end
    it 'redirects to index' do
      delete :destroy, params: {id:answer}
      expect(response).to redirect_to questions_path
    end
  end
end
