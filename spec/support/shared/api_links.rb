# frozen_string_literal: true

shared_examples_for 'API links' do
  it 'have attachment link' do
    %w[id name url created_at updated_at].each do |attribute|
      expect(json_example['links'][0][attribute]).to eq target_object.links.first.send(attribute).as_json
    end
  end
end
