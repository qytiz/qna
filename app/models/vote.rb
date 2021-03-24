# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :score, inclusion: { in: [-1, 0, 1], message: 'No double votes!' }
  validate :author_cannot_vote

  private

  def author_cannot_vote
    errors.add(:user, 'No self votes!') if user&.author?(votable)
  end
end
