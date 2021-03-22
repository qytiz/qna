# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :score, inclusion: { in: [-1, 1], message: 'No double votes!' }
  validate :author_cannot_vote

  def self.upvote(user, votable)
    vote = Vote.find_or_initialize_by(user: user, votable: votable)
    vote.score += 1
    destroy_if_revote(vote)
  end

  def self.downvote(user, votable)
    vote = Vote.find_or_initialize_by(user: user, votable: votable)
    vote.score -= 1
    destroy_if_revote(vote)
  end

  def self.destroy_if_revote(vote)
    return vote unless vote.score.zero?

    vote.destroy
    nil
  end

  private

  def author_cannot_vote
    errors.add(:user, 'No self votes!') if user&.author?(votable)
  end
end
