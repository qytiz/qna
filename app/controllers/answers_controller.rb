class AnswersController < ApplicationController
  def index; end

  def new
    @answer = question.answers.new
  end

  def create
    @answer = question.answers.build(answer_params)
    if @answer.save
      redirect_to [question, :answers]
    else
      render :new
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:title,:correct?)
  end
end