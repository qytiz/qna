# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true

  def have_best_answer?
    !!answers.find_by(best_answer: true)
  end
end
