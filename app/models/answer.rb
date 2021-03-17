# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :title, presence: true

  scope :best_first, -> { order(best_answer: :desc) }
end
