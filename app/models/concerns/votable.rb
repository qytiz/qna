# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, score_change)
    vote = Vote.find_or_initialize_by(user: user, votable: self)
    vote.score += score_change

    return vote.delete_if_revote if vote.score.zero?
    return vote unless vote.valid?

    vote.save
    vote
  end

  def total_score
    votes.sum(:score)
  end
end
