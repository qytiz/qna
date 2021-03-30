# frozen_string_literal: true

class AwardsController < ApplicationController
  authorize_resource
  def index
    @awards = current_user&.awards
  end
end
