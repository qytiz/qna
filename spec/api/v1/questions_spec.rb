# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let!(:fields) { %w[id title body user_id created_at updated_at] }
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:json_example) { json['questions'].first }
      let!(:target_object) { question }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API return status' do
        let(:expected_status) { 200 }
      end

      it_behaves_like 'API return all public fields'

      it 'return list of question' do
        expect(json['questions'].size).to eq 2
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let!(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'return list of answers' do
          expect(question_response['answers'].size).to eq 3
        end
      end
    end
  end

  describe 'GET /api/v1/questions/show' do
    include ActionDispatch::TestProcess::FixtureFile

    let!(:file1) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let!(:file2) { fixture_file_upload("#{Rails.root}/spec/spec_helper.rb", 'text/plain') }
    let!(:question) { create(:question, files: [file1, file2]) }
    let!(:link) { create(:link, linkable: question) }
    let!(:comment) { create(:comment, commentable: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let!(:access_token) { create(:access_token) }
      let(:json_example) { json['question'] }
      let!(:target_object) { question }

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

  describe 'POST /api/v1/questions/create' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:valid_question_params) { attributes_for(:question) }
      let!(:invalid_question_params) { attributes_for(:question, :invalid) }

      context 'valid data' do
        before do
          post api_path, params: { access_token: access_token.token, question: valid_question_params }.to_json,
                         headers: headers
        end

        it_behaves_like 'API return status' do
          let(:expected_status) { 200 }
        end

        it 'return all public fields' do
          expect(json['question']['title']).to eq valid_question_params[:title].as_json
          expect(json['question']['body']).to eq valid_question_params[:body].as_json
        end
      end

      context 'invalid data' do
        before do
          post api_path, params: { access_token: access_token.token, question: invalid_question_params }.to_json,
                         headers: headers
        end

        it_behaves_like 'API return status' do
          let(:expected_status) { 422 }
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:access_token) { create(:access_token) }
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let(:other_question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    context 'Authorized' do
      context 'Author' do
        context 'valid data' do
          let!(:valid_question_params) { { title: 'new title', body: 'new body' } }

          before do
            patch api_path, params: { access_token: access_token.token, question: valid_question_params }.to_json,
                            headers: headers
          end

          it_behaves_like 'API return status' do
            let(:expected_status) { 200 }
          end

          it 'return all public fields' do
            expect(json['question']['title']).to eq valid_question_params[:title].as_json
            expect(json['question']['body']).to eq valid_question_params[:body].as_json
          end
        end

        context 'invalid data' do
          let!(:invalid_question_params) { { title: '', body: 'new body' } }

          before do
            patch api_path, params: { access_token: access_token.token, question: invalid_question_params }.to_json,
                            headers: headers
          end

          it_behaves_like 'API return status' do
            let(:expected_status) { 422 }
          end
        end
      end

      context 'not author' do
        let!(:valid_question_params) { { title: 'new title', body: 'new body' } }
        let(:api_path) { "/api/v1/questions/#{other_question.id}" }

        before do
          patch api_path, params: { access_token: access_token.token, question: valid_question_params }.to_json,
                          headers: headers
        end

        it_behaves_like 'API return status' do
          let(:expected_status) { 403 }
        end
      end
    end
  end

  describe 'delete /api/v1/questions/:id' do
    let!(:access_token) { create(:access_token) }
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let(:other_question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    context 'Authorized' do
      context 'author' do
        context 'valid data' do
          before { delete api_path, params: { access_token: access_token.token }.to_json, headers: headers }

          it_behaves_like 'API return status' do
            let(:expected_status) { 204 }
          end
        end
      end

      context 'not author' do
        let!(:valid_question_params) { { title: 'new title', body: 'new body' } }
        let(:api_path) { "/api/v1/questions/#{other_question.id}" }

        before do
          patch api_path, params: { access_token: access_token.token, question: valid_question_params }.to_json,
                          headers: headers
        end

        it_behaves_like 'API return status' do
          let(:expected_status) { 403 }
        end
      end
    end
  end
end
