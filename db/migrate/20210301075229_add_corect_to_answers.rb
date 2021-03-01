class AddCoorectToAndswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :correct?, :boolean, default: false
  end
end
