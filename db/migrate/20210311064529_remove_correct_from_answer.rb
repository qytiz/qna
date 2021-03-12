class RemoveCorrectFromAnswer < ActiveRecord::Migration[6.1]
  def change
    remove_column :answers, :correct
  end
end
