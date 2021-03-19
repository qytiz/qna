# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :title, presence: true

  scope :best_first, -> { order(best_answer: :desc) }

  def set_best
    old_best_answer = question.answers.find_by(best_answer: true) if question.have_best_answer?
    Answer.transaction do
      old_best_answer.update!(best_answer: false) if old_best_answer.present?
      update!(best_answer: true)
    end
  end
end
