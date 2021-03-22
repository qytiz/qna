# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }
  def a_gist?
    url.start_with?('https://gist.github.com/qytiz/')
  end
end
