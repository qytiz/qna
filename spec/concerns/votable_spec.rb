# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Votable do
  let!(:user) { create(:user) }
  let!(:answer) { create(:answer) }

  it { expect(answer.upvote(user).score).to eq 1 }
  it { expect(answer.downvote(user).score).to eq(-1) }
  it 'Total score of votable' do
    create_list(:vote, 5, user: create(:user), score: 1, votable: answer)
    expect(answer.total_score).to eq 5
  end
end
