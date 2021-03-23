# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voted do
  let!(:user) { create(:user) }
  let!(:answer) { create(:answer) }

  it { expect(answer.upvote(user).score).to eq 1 }
  it { expect(answer.downvote(user).score).to eq(-1) }
end
