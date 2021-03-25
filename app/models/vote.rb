# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :score, inclusion: { in: [-1, 1], message: 'No double votes!' }
  validate :author_cannot_vote

  def delete_if_revote
    destroy
  end

  private

  def author_cannot_vote
    errors.add(:user, 'No self votes!') if user&.author?(votable)
  end
end
