# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAnswerAlertJob, type: :job do
  let(:service) { double(':NewAnswerAlertService') }
  let(:question) { create(:question) }

  before do
    allow(NewAnswerAlertService).to receive(:new).and_return(service)
  end

  it 'calls NewAnswerAlertService#send_alert' do
    expect(service).to receive(:send_alert)
    NewAnswerAlertJob.perform_now(question)
  end
end
