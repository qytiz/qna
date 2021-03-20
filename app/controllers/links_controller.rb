class LinksController < ApplicationController
  before_action :authenticate_user!


  def destroy
    link.destroy if current_user.author?(link.linkable)
  end

  private

  def link
    @link ||= Link.find(params[:link]) 
  end

end