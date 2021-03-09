class ChangeToCorrect < ActiveRecord::Migration[6.1]
  def change
    rename_column :answers, :correct?, :correct
  end
end
