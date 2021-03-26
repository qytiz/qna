# frozen_string_literal: true

module PauseHelpers
  def pause
    $stderr.write 'Press enter to continue'
    $stdin.gets
  end
end
