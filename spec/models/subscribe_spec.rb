# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  describe 'shoulda validations' do
    subject { create(:subscribe) }

    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  describe 'raise error if same  subscribe already exist' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:subscribe) { create(:subscribe, question: question, user: user) }
    let!(:other_subscribe) { build(:subscribe, question: question, user: user) }
    it 'raise error' do
      other_subscribe.valid?
      expect(other_subscribe.errors.count).to eq 1
    end
  end
end
