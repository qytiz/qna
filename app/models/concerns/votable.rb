# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def upvote(user)
    vote = Vote.find_or_initialize_by(user: user, votable: self)
    vote.score += 1
    vote.destroy_if_revote
  end

  def downvote(user)
    vote = Vote.find_or_initialize_by(user: user, votable: self)
    vote.score -= 1
    vote.destroy_if_revote
  end

  def total_score
    votes.sum(:score)
  end
end
