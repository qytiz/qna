# frozen_string_literal: true

class CreateSubscribes < ActiveRecord::Migration[6.1]
  def change
    create_table :subscribes do |t|
      t.belongs_to :question, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
