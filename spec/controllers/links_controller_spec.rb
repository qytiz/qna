# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'DELETE#delete' do
    before do
      question.links.build(linkable: question, name: 'Example link', url: 'http://example.url')
      question.save
    end

    context 'Author of question' do
      before { login(user) }

      it 'deletes link' do
        question.reload
        expect do
          delete :destroy, params: { id: question, link: question.links.first },
                           format: :js
        end.to change(question.links, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question, link: question.links.first }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'not author of question' do
      before { login(create(:user)) }

      it ' tries to delete link' do
        expect do
          delete :destroy, params: { id: question, link: question.links.first },
                           format: :js
        end.to_not change(question.links, :count)
      end

      it 're-renders destroy view' do
        delete :destroy, params: { id: question, link: question.links.first }, format: :js

        expect(response).to render_template :destroy
      end
    end
  end
end
