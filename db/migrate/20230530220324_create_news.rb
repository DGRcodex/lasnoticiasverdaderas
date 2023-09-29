class CreateNews < ActiveRecord::Migration[7.0]
  def change
    create_table :news do |t|
      t.string :title
      t.string :imagen
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
