# frozen_string_literal: true

class NewAnswerAlertService
  def send_alert(subcribes)
    subcribes.find_each do |subcribe|
      NewAnswerMailer.alert(subcribe).deliver_later
    end
  end
end
