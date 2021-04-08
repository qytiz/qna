# frozen_string_literal: true

shared_examples_for 'API comments' do
  it 'have attached comments' do
    %w[id body created_at updated_at].each do |attribute|
      expect(json_example['comments'][0][attribute]).to eq target_object.comments.first.send(attribute).as_json
    end
  end
end
