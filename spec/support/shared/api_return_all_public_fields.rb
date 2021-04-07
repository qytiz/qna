# frozen_string_literal: true

shared_examples_for 'API return all public fields' do
  it 'return all public fields' do
    fields&.each do |attribute|
      expect(json_example[attribute]).to eq target_object.send(attribute).as_json
    end
  end
end
