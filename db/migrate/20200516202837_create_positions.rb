class CreatePositions < ActiveRecord::Migration[6.0]
  def change
    create_table :positions do |t|
      t.string :signature
      t.integer :draws, default: 0
      t.integer :black_wins, default: 0
      t.integer :white_wins, default: 0
      t.integer :piece_size
      t.timestamps
    end
    add_index :positions, :signature
  end
end
