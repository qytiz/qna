class CreateAwardOwnings < ActiveRecord::Migration[6.1]
  def change
    create_table :award_ownings do |t|
          t.references :user, null: false
          t.references :award, null: false
    
          t.timestamps
    end
  end
end
