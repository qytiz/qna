class Answer < ApplicationRecord
  validates :title, presence: true
  belongs_to :question
end
