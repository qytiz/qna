# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :subscribes, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :award, dependent: :destroy

  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :subscribe_creator_for_question

  scope :new_questions, -> { where('created_at > ?', 1.day.ago) }

  def have_best_answer?
    !!answers.find_by(best_answer: true)
  end

  private

  def subscribe_creator_for_question
    subscribes.create(user: user)
  end
end
