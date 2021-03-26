# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  let!(:answer) { create(:answer) }

  it 'Delete if revote' do
    vote = answer.vote(user, 1)
    expect(Vote.last).to eq vote
    answer.vote(user, -1)
    expect(Vote.last).to eq nil
  end
end
