# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    authorize! :destroy, link
    link.destroy
  end

  private

  def link
    @link ||= Link.find(params[:link])
  end
end
