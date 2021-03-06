# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  include Voted
  after_action :publish_question, only: [:create]
  after_action :set_question_for_gon, only: [:show]
  expose :comment, -> { question.comments.new }

  def index
    authorize! :index, Question
    @questions = Question.all
  end

  def show
    authorize! :show, Question
    @answer ||= question.answers.new
    @answer.links.new
  end

  def new
    authorize! :new, Question
    question.links.new
    question.build_award
  end

  def create
    authorize! :create, Question
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question sucessfully created.'
    else
      render :new
    end
  end

  def edit
    authorize! :edit, Question
  end

  def update
    authorize! :update, question
    question.update(question_params)
  end

  def destroy
    authorize! :destroy, question
    question.destroy
    redirect_to questions_path, notice: 'Question delited sucessfully'
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast 'questions', { question: @question, user_id: current_user.id }
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def set_question_for_gon
    gon.question_id = question.id
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [], links_attributes: %i[name url], award_attributes: %i[title file])
  end
end
