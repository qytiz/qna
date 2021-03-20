class CreateAwards < ActiveRecord::Migration[6.1]
  def change
    create_table :awards do |t|
      t.belongs_to :question, null: false, foreign_key: true

      t.string :title

      t.timestamps
    end
  end
end
