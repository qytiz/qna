# frozen_string_literal: true

class AwardsController < ApplicationController
  skip_authorization_check
  def index
    @awards = current_user&.awards
  end
end
