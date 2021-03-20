# frozen_string_literal: true

class FilesController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @resource = @file.record
    @file.purge if current_user&.author?(@resource)
  end
end
