# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  let!(:answer) { create(:answer) }

  it 'Test delete if revote' do
    vote = answer.upvote(user)
    vote.save
    expect(vote.destroy_if_revote).to eq vote
    vote = answer.downvote(user)
    expect(vote).to eq nil
  end
end
