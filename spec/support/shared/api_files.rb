# frozen_string_literal: true

shared_examples_for 'API files' do
  include Rails.application.routes.url_helpers

  it 'have attachment file link' do
    target_object.files.each_with_index do |file, index|
      expect(json_example['file_urls'][index]).to eq rails_blob_url(file, only_path: true)
    end
  end
end
