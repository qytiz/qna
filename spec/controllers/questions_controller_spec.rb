# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'Get #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'Get #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns a new Link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'Get #new' do
    before do
      sign_in(user)
      get :new
    end

    it 'assigns a new Link for @link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'Get #edit' do
    before do
      sign_in(user)
      get :edit, params: { id: question }
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves a new  question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not saves the question' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question, user: user) }

    context 'User unlogined' do
      it 'not change question' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end

    context 'User logined' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirect to updated question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to redirect_to :question
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'does not change' do
          question.reload
          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end
      end

      context 'other user question' do
        let(:user) { create(:user) }
        before { login(user) }

        it 'Not edit' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          question.reload
          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'Author' do
      let!(:question) { create :question, user: user }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question, user: user } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not author' do
      let!(:question) { create(:question) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'Get 403 status' do
        delete :destroy, params: { id: question }, format: :js
        expect(response).to have_http_status 403
      end
    end
  end
end
