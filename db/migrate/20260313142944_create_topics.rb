class CreateTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :topics do |t|
      t.string :title
      t.text :description
      t.text :ai_instructions

      t.timestamps
    end
  end
end
