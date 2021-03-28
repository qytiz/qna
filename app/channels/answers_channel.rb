# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_#{params[:question_id]}/answers"
  end

  def do_something(text)
    Rails.logger.info text
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
