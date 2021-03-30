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
      answer.update(answer_params) if can?(:update, answer)
  end

  def destroy
    answer.destroy if can?(:destroy, answer)
  end

  def mark_best
    @question = answer.question
    answer.set_best if can?(:mark_best,answer)
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
