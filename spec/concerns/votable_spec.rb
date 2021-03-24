# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Votable do
  let!(:user) { create(:user) }
  let!(:answer) { create(:answer) }

  it do
    answer.upvote(user)
    expect(answer.votes.last.score).to eq 1
  end
  it do
    answer.downvote(user)
    expect(answer.votes.last.score).to eq(-1)
  end
  it 'Total score of votable' do
    create_list(:vote, 5, user: create(:user), score: 1, votable: answer)
    expect(answer.total_score).to eq 5
  end
end
