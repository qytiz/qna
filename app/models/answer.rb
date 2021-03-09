class Answer < ApplicationRecord
  belongs_to :question
  
  validates :title, presence: true

  def right
    if self.correct?
       'right'
    else 
       'wrong'
    end
  end
end
