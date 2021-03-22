# frozen_string_literal: true

class Award < ApplicationRecord
  belongs_to :question

  has_one_attached :file

  has_one :award_owning, dependent: :destroy
  has_one :user, through: :award_owning

  validates :title, presence: true

  def reward_the_user(answer_user)
    self.update(user: answer_user)
  end
end
