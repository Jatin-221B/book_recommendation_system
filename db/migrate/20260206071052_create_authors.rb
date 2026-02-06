class CreateAuthors < ActiveRecord::Migration[8.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :string
      t.string :bio
      t.string :text

      t.timestamps
    end
  end
end
