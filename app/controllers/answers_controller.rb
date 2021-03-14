# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question_path(question), notice: 'New answer sucessfully created'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user&.author?(answer)
      answer.destroy
      redirect_to questions_path, notice: 'Answer delited sucessfully'
    else
      redirect_to questions_path, alert: 'You are not owner of this answer'
    end
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
    params.require(:answer).permit(:title)
  end
end
