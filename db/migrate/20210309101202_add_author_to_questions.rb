# frozen_string_literal: true

class AddAuthorToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :user, foreign_key: true
  end
end
