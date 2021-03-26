# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Votable do
  let!(:user) { create(:user) }
  let!(:answer) { create(:answer) }

  it 'Upvote metod' do
    answer.vote(user, 1)
    expect(answer.votes.last.score).to eq 1
  end

  it 'Downvote metod' do
    answer.vote(user, -1)
    expect(answer.votes.last.score).to eq(-1)
  end

  it 'Total score of votable' do
    create_list(:vote, 5, user: create(:user), score: 1, votable: answer)
    create_list(:vote, 2, user: create(:user), score: -1, votable: answer)
    expect(answer.total_score).to eq 3
  end
end
