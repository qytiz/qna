# frozen_string_literal: true

class NewAnswerAlertMailer < ApplicationMailer
  def alert
    mail to: subscribe.user.email
  end
end
