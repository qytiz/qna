# frozen_string_literal: true

class AwardsController < ApplicationController
  def index
    @awards = current_user&.awards
  end
end
