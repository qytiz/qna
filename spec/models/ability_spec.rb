# frozen_string_literal: true

require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }
  describe 'For guest' do
    let!(:user) { nil }
    
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'For admin' do
    let!(:user) { create :user, admin: true }
    it { should be_able_to :manage, :all }
  end

  describe 'For user' do
    let!(:user) { create :user }
    let!(:other) { create :user }
    let!(:question) { create :question, user: user }
    let!(:other_question) { create :question, user: other }
    let!(:commentable) { create :answer, user: user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other) }
    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other) }
    it { should be_able_to :update, create(:comment, user: user, commentable: commentable) }
    it { should_not be_able_to :update, create(:comment, user: other, commentable: commentable) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other) }
    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer, user: other) }
    it { should be_able_to :destroy, create(:comment, user: user, commentable: commentable) }
    it { should_not be_able_to :destroy, create(:comment, user: other, commentable: commentable) }

    it { should be_able_to :mark_best, create(:answer, user: user, question: question) }
    it { should_not be_able_to :mark_best, create(:answer, user: user, question: other_question) }

    it { should be_able_to :upvote, create(:answer, user: other) }
    it { should be_able_to :downvote, create(:answer, user: other) }
    it { should be_able_to :delete_vote, create(:answer, user: other) }

    it { should_not be_able_to :upvote, create(:answer, user: user) }
    it { should_not be_able_to :downvote, create(:answer, user: user) }
    it { should_not be_able_to :delete_vote, create(:answer, user: user) }

    it 'can destroy file' do
      question.files.attach(
        io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
        filename: 'rails_helper.rb'
      )

      file = question.files.first
      should be_able_to :destroy, file
    end

    it 'can not destroy file' do
      other_question.files.attach(
        io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
        filename: 'rails_helper.rb'
      )

      file = other_question.files.first
      should_not be_able_to :destroy, file
    end

    it { should be_able_to :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_question) }
  end
end
