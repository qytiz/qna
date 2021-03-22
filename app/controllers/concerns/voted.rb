# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  def upvote
    vote = Vote.upvote(current_user, votable)
    respond_to do |format|
      format.json do
        if vote.nil? || vote.save
          render json: { object_id: votable.id, total_score: votable.total_score, model: votable.class.name.underscore }
        else
          render json: vote.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def downvote
    vote = Vote.downvote(current_user, votable)
    respond_to do |format|
      format.json do
        if vote.nil? || vote.save
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
