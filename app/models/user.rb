# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscribes, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :award_ownings, dependent: :destroy
  has_many :awards, through: :award_ownings

  scope :all_without_this, ->(user) { where.not(id: user.id) }

  def author?(object)
    id == object.user_id
  end

  def subscribed?(question)
    subscribes.where(question: question).exists?
  end
end
