# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      def index
        authorize! :index, Question
        @questions = Question.all
        render json: @questions, each_serializer: QuestionsSerializer
      end

      def show
        authorize! :show, Question
        render json: question, serializer: QuestionSerializer
      end

      def create
        authorize! :create, Question
        @question = Question.new(question_params)
        @question.user_id = current_resource_owner.id
        if @question.save
          render json: @question, serializer: QuestionSerializer
        else
          head :forbidden
        end
      end

      def update
        authorize! :update, question
        if question.update(question_params)
          render json: @question, serializer: QuestionSerializer
        else
          head :forbidden
        end
      end

      def destroy
        authorize! :destroy, question
        if question.destroy
          render json: 'delited sucessfully'.to_json
        else
          head :forbidden
        end
      end

      private

      def question
        @question = Question.with_attached_files.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:title, :body,
                                         links_attributes: %i[name url], award_attributes: %i[title file])
      end
    end
  end
end
