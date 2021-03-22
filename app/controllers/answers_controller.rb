# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
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

  def question
    @question ||= Question.find(params[:question_id])
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
