# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscribesController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }
    context 'user authorised' do
      let!(:user) { create(:user) }
      before { sign_in(user) }

      it 'create a new subscribe' do
        expect do
          post :create,
               params: { question_id: question, subscribe: attributes_for(:subscribe, question: question, user: user) }
        end.to change(Subscribe, :count).by(1)
      end

      it "can't create double subscribe" do
        post :create,
             params: { question_id: question, subscribe: attributes_for(:subscribe, question: question, user: user) }
        expect do
          post :create,
               params: { question_id: question, subscribe: attributes_for(:subscribe, question: question, user: user) }
        end.to_not change(Subscribe, :count)
      end
    end

    context 'user Unauthorised' do
      it 'not create a new  subscribe' do
        expect do
          post :create,
               params: { question_id: question, subscribe: attributes_for(:subscribe, :unlogined) }
        end.to_not change(Subscribe, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:subscribe) { create(:subscribe, user: user, question: question) }

    context 'user authorised' do
      before { sign_in(user) }

      it 'delete subscribe' do
        expect { delete :destroy, params: { id: subscribe, question_id: question } }.to change(Subscribe, :count).by(-1)
      end
    end

    context 'user Unauthorised' do
      it 'not delete subscribe' do
        expect { delete :destroy, params: { id: subscribe, question_id: question } }.to_not change(Subscribe, :count)
      end
    end
  end
end
