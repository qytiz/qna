# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:comment) { create(:comment, user: user, commentable: question) }

  context '#POST create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'With valid attributes' do
        it 'set commentable' do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
          expect(assigns(:commentable)).to eq question
        end

        it 'create comment in the database' do
          expect do
            post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
          end.to change(question.comments, :count).by(1)
        end

        it 'render create' do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'With invalid attributes' do
        it 'finds commentable' do
          post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js
          expect(assigns(:commentable)).to eq question
        end

        it "doesn't create comment in the database" do
          expect do
            post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js
          end.to_not change(question.comments, :count)
        end

        it 'renders create' do
          post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'Unauthenticated user' do
      it "doesn't create comment in the database" do
        expect do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
        end.to_not change(Comment, :count)
      end
    end
  end
end
