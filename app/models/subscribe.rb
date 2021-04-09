# frozen_string_literal: true

class Subscribe < ApplicationRecord
  scope :for, ->(user, question) { find_by(user: user, question: question) }
  belongs_to :question
  belongs_to :user
  validate :alredy_created, on: :create

  private

  def alredy_created
    errors.add('You alredy subscribed') if user.subscribed?(question)
  end
end
