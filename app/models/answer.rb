# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :title, presence: true

  scope :best_first, -> { order(best_answer: :desc) }

  def set_best
    question = self.question
    if question.have_best_answer?
      old_best_answer = question.answers.find_by(best_answer: true)
      Answer.transaction do
        old_best_answer.update(best_answer: false)
        update(best_answer: true)
      end
      return
    end
    update(best_answer: true)
  end
end
