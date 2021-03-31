# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  after_action :publish_comment, only: :create
  expose :comment
  authorize_resource

  def create
    @commentable.comments << comment
    comment.user = current_user
    comment.save
  end

  private

  def set_commentable
    @resource, @resource_id = request.path.split('/')[1, 2]
    @resource = @resource.singularize
    @commentable = @resource.classify.constantize.find(@resource_id)
  end

  def publish_comment
    return if comment.errors.any?

    question_id = @commentable.instance_of?(Question) ? @commentable.id : @commentable.question_id
    ActionCable.server.broadcast(
      "question_#{question_id}_comments",
      comment: comment,
      user: comment.user,
      commentable_type: @commentable.class.to_s.downcase
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
