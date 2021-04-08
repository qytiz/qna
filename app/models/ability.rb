# frozen_string_literal: true

class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abbilities : user_abbilities
    else
      guest_abbilities
    end
  end

  def guest_abbilities
    can :read, :all
  end

  def admin_abbilities
    can :manage, :all
  end

  def user_abbilities
    guest_abbilities

    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer, Comment], user_id: user.id

    can :mark_best, Answer do |answer|
      user.author?(answer.question)
    end

    can [:upvote, :downvote], [Answer, Question] do |votable|
      !user.author?(votable)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      user.author?(file.record)
    end

    can :destroy, Link do |link|
      user.author?(link.linkable)
    end

    can :me, User do |profile|
      profile.id == user.id
    end
  end
end
