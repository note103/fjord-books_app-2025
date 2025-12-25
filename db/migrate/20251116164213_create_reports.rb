class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
