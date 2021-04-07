# frozen_string_literal: true

shared_examples_for 'API return status' do
  it 'returns status' do
    expect(response.status).to eq expected_status
  end
end
