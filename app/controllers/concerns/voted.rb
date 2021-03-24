# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  def upvote
    vote = votable.upvote(current_user)
    respond_to do |format|
      format.json do
        if vote == true
          render json: { object_id: votable.id, total_score: votable.total_score, model: votable.class.name.underscore }
        else
          render json: vote.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def downvote
    vote = votable.downvote(current_user)
    respond_to do |format|
      format.json do
        if vote == true
          render json: { object_id: votable.id, total_score: votable.total_score, model: votable.class.name.underscore }
        else
          render json: vote.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def votable
    send(controller_name.singularize)
  end
end
