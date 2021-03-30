# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!
  def destroy
    link.destroy if can?(:destroy, link)
  end

  private

  def link
    @link ||= Link.find(params[:link])
  end
end
