# frozen_string_literal: true

class NewAnswerAlertJob < ApplicationJob
  queue_as :default

  def perform(question)
    NewAnswerAlertService.new.send_alert(question.subscribes)
  end
end
