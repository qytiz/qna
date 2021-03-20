class AwardOwning < ApplicationRecord
  belongs_to :user
  belongs_to :award
end
