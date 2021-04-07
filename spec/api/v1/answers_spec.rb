# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let!(:fields) { %w[id title question_id created_at updated_at] }
  let!(:question) { create(:question) }
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/answers/show' do
    include ActionDispatch::TestProcess::FixtureFile

    let!(:file1) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let!(:file2) { fixture_file_upload("#{Rails.root}/spec/spec_helper.rb", 'text/plain') }
    let!(:answer) { create(:answer, files: [file1, file2]) }
    let!(:comment) { create(:comment, commentable: answer) }
    let!(:link) { create(:link, linkable: answer) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let!(:access_token) { create(:access_token) }
      let(:json_example) { json['answer'] }
      let!(:target_object) { answer }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API return status' do
        let(:expected_status) { 200 }
      end

      it_behaves_like 'API return all public fields'

      it_behaves_like 'API files'

      it_behaves_like 'API links'

      it_behaves_like 'API comments'
    end
  end

  describe 'POST /api/v1/answers/create' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    context 'Authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:valid_answer_params) { attributes_for(:answer) }
      let!(:invalid_answer_params) { attributes_for(:answer, :invalid) }

      context 'valid data' do
        before do
          post api_path, params: { access_token: access_token.token, answer: valid_answer_params }.to_json,
                         headers: headers
        end

        it_behaves_like 'API return status' do
          let(:expected_status) { 200 }
        end

        it 'return all public fields' do
          expect(json['answer']['title']).to eq valid_answer_params[:title].as_json
          expect(json['answer']['body']).to eq valid_answer_params[:body].as_json
        end
      end

      context 'invalid data' do
        before do
          post api_path,
               params: { access_token: access_token.token, question_id: question.id, answer: invalid_answer_params }.to_json, headers: headers
        end

        it_behaves_like 'API return status' do
          let(:expected_status) { 403 }
        end
      end
    end
  end
end
