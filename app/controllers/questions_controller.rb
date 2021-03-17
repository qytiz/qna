# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  def index
    @questions = Question.all
  end

  def show
    @answer ||= question.answers.new
  end

  def new; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question sucessfully created.'
    else
      render :new
    end
  end

  def update
    @question = Question.find(params[:id])
    @question.update(question_params)
  end

  def destroy
    if current_user&.author?(question)
      question.destroy
      redirect_to questions_path, notice: 'Question delited sucessfully'
    else
      redirect_to questions_path, alert: 'You are not owner of this question'
    end
  end

  def mark_best
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if current_user&.author?(question)

      if @question.best_answer?
        old_best_answer = @question.answers.find_by(best_answer: true)
        old_best_answer.update(best_answer: false)
      end
      @answer.update(best_answer: true)
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
