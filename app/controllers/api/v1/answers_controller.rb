# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      authorize_resource

      def show
        authorize! :show, Answer
        render json: answer, serializer: AnswerSerializer
      end

      def create
        authorize! :create, Answer
        @answer = Answer.new(answer_params)
        @answer.user_id = current_resource_owner.id
        @answer.question_id = params[:question_id]
        if @answer.save
          render json: @answer
        else
          head :forbidden
        end
      end

      private

      def answer
        @answer = Answer.with_attached_files.find(params[:id])
      end

      def answer_params
        params.require(:answer).permit(:title, files: [], links_attributes: %i[name url])
      end
    end
  end
end
