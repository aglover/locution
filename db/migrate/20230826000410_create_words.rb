class CreateWords < ActiveRecord::Migration[7.0]
  def change
    create_table :words do |t|
      t.string :word
      t.string :part_of_speech

      t.timestamps
    end
  end
end
