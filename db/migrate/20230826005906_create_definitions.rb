class CreateDefinitions < ActiveRecord::Migration[7.0]
  def change
    create_table :definitions do |t|
      t.string :definition
      t.string :example_sentence
      t.references :word, null: false, foreign_key: true

      t.timestamps
    end
  end
end
