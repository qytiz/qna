# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let!(:fields) { %w[id email admin created_at updated_at] }
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'Get api/v1/profilers/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    context 'unauthorized' do
      it_behaves_like 'API authorizable' do
        let(:method) { :get }
      end
    end

    context 'Authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:json_example) { json['user'] }
      let!(:target_object) { user }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API return status' do
        let(:expected_status) { 200 }
      end

      it_behaves_like 'API return all public fields'

      it 'not returns private fields' do
        %w[password encrypted_password].each do |attribute|
          expect(json['user']).to_not have_key(attribute)
        end
      end
    end
  end

  describe 'Get api/v1/profilers/index' do
    let(:api_path) { '/api/v1/profiles' }

    context 'unauthorized' do
      it_behaves_like 'API authorizable' do
        let(:method) { :get }
      end
    end

    context 'Authorized' do
      let!(:users) { create_list(:user, 3) }
      let!(:user) { users.last }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:json_example) { json['users'].first }
      let!(:target_object) { users.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API return status' do
        let(:expected_status) { 200 }
      end

      it_behaves_like 'API return all public fields'

      it 'return list of users without current user' do
        expect(json['users'].size).to eq 2
      end

      it 'not returns private fields' do
        %w[password encrypted_password].each do |attribute|
          expect(json['users'][0]).to_not have_key(attribute)
        end
      end
    end
  end
end
