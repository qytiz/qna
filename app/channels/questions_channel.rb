# frozen_string_literal: true

class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'questions'
  end

  def do_something(text)
    Rails.logger.info text
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
