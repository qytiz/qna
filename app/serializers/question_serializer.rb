# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :user_id, :created_at, :updated_at, :file_urls, :links

  has_many :comments

  def file_urls
    file_urls = []
    object.files.each do |file|
      file_urls << rails_blob_url(file, only_path: true)
    end
    file_urls
  end
end
