# frozen_string_literal: true

shared_examples 'voted controller' do
  let!(:votable) { create(described_class.controller_name.singularize.to_sym) }
  let!(:user) { create(:user) }
  let!(:own_votable) { create(described_class.controller_name.singularize.to_sym, user: user) }

  describe 'POST #upvote' do
    context 'Authenticated user' do
      before { login user }

      context 'with others votable' do
        it 'can vote' do
          expect { post :upvote, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(1)
          expect(votable.votes.last.score).to eq(1)
        end

        it 'return json' do
          post :upvote, params: { id: votable }, format: :json
          json_response = JSON.parse(response.body)
          expect(json_response['model']).to eq votable.class.name.underscore
          expect(json_response['object_id']).to eq votable.id
          expect(json_response['total_score']).to eq 1
        end

        it "can't vote twice" do
          2.times { post :upvote, params: { id: votable }, format: :json }
          json_response = JSON.parse(response.body)
          expect(response.status).to eq 422
          expect(json_response['score']).to eq ['No double votes!']
        end
      end

      context 'with own votable' do
        it "can't vote" do
          expect { post :upvote, params: { id: own_votable }, format: :json }.to_not change(own_votable.votes, :count)
        end
      end
    end

    context 'Unauthenticated user' do
      it "can't vote" do
        expect { post :upvote, params: { id: votable }, format: :json }.to_not change(votable.votes, :count)
      end

      it '401 status' do
        post :upvote, params: { id: votable }, format: :json
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST #downvote' do
    context 'Authenticated user' do
      before { login user }

      context 'with others votable' do
        it 'can vote' do
          expect { post :downvote, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(1)
          expect(votable.votes.last.score).to eq(-1)
        end

        it 'render json' do
          post :downvote, params: { id: votable }, format: :json
          json_response = JSON.parse(response.body)
          expect(json_response['model']).to eq votable.class.name.underscore
          expect(json_response['object_id']).to eq votable.id
          expect(json_response['total_score']).to eq(-1)
        end

        it 'can not vote twice' do
          2.times { post :downvote, params: { id: votable }, format: :json }
          json_response = JSON.parse(response.body)
          expect(response.status).to eq 422
          expect(json_response['score']).to eq ['No double votes!']
        end
      end

      context 'with own votable' do
        it 'can not vote' do
          expect { post :downvote, params: { id: own_votable }, format: :json }.to_not change(votable.votes, :count)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can not vote' do
        expect { post :upvote, params: { id: votable }, format: :json }.to_not change(votable.votes, :count)
      end

      it '401 status' do
        post :upvote, params: { id: votable }, format: :json
        expect(response).to have_http_status(401)
      end
    end
  end
end
