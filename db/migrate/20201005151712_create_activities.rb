class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.string :signature
      t.integer :draws, default: 0
      t.integer :black_wins, default: 0
      t.integer :white_wins, default: 0
      t.timestamps
    end
  end
end
