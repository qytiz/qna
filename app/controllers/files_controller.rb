# frozen_string_literal: true

class FilesController < ApplicationController
  skip_authorization_check
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @file
    @resource = @file.record
    @file.purge
  end
end
