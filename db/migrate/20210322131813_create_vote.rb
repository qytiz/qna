# frozen_string_literal: true

class CreateVote < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :score, default: 0, null: false
      t.belongs_to :user, foreign_key: true
      t.belongs_to :votable, polymorphic: true

      t.timestamps
    end
  end
end
