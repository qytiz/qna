# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      expose :question, -> { Question.find(params[:question_id]) }

      def show
        authorize! :show, Answer
        render json: answer, serializer: AnswerSerializer
      end

      def create
        authorize! :create, Answer
        @answer = question.answers.create(answer_params)
        @answer.user = current_resource_owner
        if @answer.save
          render json: @answer
        else
          render json: @answer.errors, status: :unprocessable_entity
        end
      end

      private

      def answer
        @answer = Answer.with_attached_files.find(params[:id])
      end

      def answer_params
        params.require(:answer).permit(:question_id, :title, files: [], links_attributes: %i[name url])
      end
    end
  end
end
