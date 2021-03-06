# frozen_string_literal: true

class FilesController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @file
    @resource = @file.record
    @file.purge
  end
end
