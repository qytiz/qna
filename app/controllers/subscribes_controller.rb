# frozen_string_literal: true

class SubscribesController < ApplicationController
  def create
    authorize! :create, Subscribe
    subscribe = Subscribe.create(question: question, user: current_user)
    redirect_to question, notice: 'You subscribed sucessfully.'
  end

  def destroy
    @subscribe = Subscribe.find(params[:id])

    authorize! :destroy, @subscribe
    @subscribe.destroy

    redirect_to @subscribe.question, notice: 'You unsubscribed sucessfully.'
  end

  private

  def question
    @question ||= Question.with_attached_files.find(params[:question_id])
  end
end
