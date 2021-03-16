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

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question sucessfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if current_user&.author?(question)
      question.destroy
      redirect_to questions_path, notice: 'Question delited sucessfully'
    else
      redirect_to questions_path, alert: 'You are not owner of this question'
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
