# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[awards]

  def awards
    @awards = current_user&.awards
  end
end
