class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def create
    @answer = question.answers.build(answer_params)
    @answer.user_id=current_user.id
    if @answer.save
      redirect_to answer_path(@answer), notice:'New answer sucessfully created'
    else
      render question
    end
  end

  def destroy
    if current_user&.author?(answer)
      answer.destroy
      redirect_to questions_path, notice:'Answer delited sucessfully'
    end
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
    params.require(:answer).permit(:title)
  end
end