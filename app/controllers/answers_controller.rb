class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  def index; end

  def new
    @answer = question.answers.new
  end

  def create
    @answer = question.answers.build(answer_params)
    if @answer.save
      redirect_to question_answer_path(question,@answer), notice:'New answer sucessfully created'
    else
      render :new
    end
  end

  def destroy
    answer.destroy
    redirect_to questions_path, notice:'Answer delited sucessfully'
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end
  def answer
    @answer ||=Answer.find(params[:id])
  end
  helper_method :question
  helper_method :answer
  def answer_params
    params.require(:answer).permit(:title,:correct)
  end
end