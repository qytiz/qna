# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern
  def upvote
    vote = votable.vote(current_user, 1)
    vote_json_return(vote)
  end

  def downvote
    vote = votable.vote(current_user, -1)
    vote_json_return(vote)
  end

  private

  def vote_json_return(vote)
    respond_to do |format|
      format.json do
        if vote.errors.empty?
          render json: { object_id: votable.id, total_score: votable.total_score, model: votable.class.name.underscore }
        else
          render json: vote.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def votable
    send(controller_name.singularize)
  end
end
