# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]
  after_action :set_answer_for_gon, only: [:create]
  expose :comment, -> { answer.comments.new }

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    if current_user&.author?(answer)
      answer.update(answer_params)
      @question = answer.question
    end
  end

  def destroy
    answer.destroy if current_user&.author?(answer)
  end

  def mark_best
    @question = answer.question
    answer.set_best if current_user&.author?(question)
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast "question_#{@answer.question.id}/answers",
                                 { answer: @answer, user_id: current_user.id }
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def set_answer_for_gon
    gon.answer_id = answer.id
    gon.user_id = current_user.id if current_user
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end
  helper_method :question
  helper_method :answer
  def answer_params
    params.require(:answer).permit(:title, files: [], links_attributes: %i[name url])
  end
end
