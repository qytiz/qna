# frozen_string_literal: true

class AwardOwning < ApplicationRecord
  belongs_to :user
  belongs_to :award
end
