# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/new_answer_alert
class NewAnswerAlertPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/new_answer_alert/alert
  def alert
    NewAnswerAlertMailer.alert
  end
end
