class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.references :user, index: true, foreign_key: true
      t.references :reminder, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
