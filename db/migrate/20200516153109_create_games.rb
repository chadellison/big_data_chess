class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.text :moves
      t.string :result
      t.timestamps
    end
    add_index(:games, :moves)
  end
end
