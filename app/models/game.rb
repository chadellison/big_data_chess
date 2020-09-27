class Game < ApplicationRecord
  def play_self(fen_notation)
    game_result = ChessValidator::GameLogic.find_game_result(fen_notation)

    if game_result
      puts 'the game is over...' + game_result
      # update game object
      # update positions
    else
      pieces_with_moves = ChessValidator::MoveLogic.find_next_moves(fen_notation)
      new_fen_notation = ChessValidator::MoveLogic.make_random_move(fen_notation, pieces_with_moves)
      puts new_fen_notation
      play_self(new_fen_notation)
    end
  end

  def calculate_position_value(iterations, fen_notation)
    position_value = 0
    iterations.times do
      position_value += play_self(fen_notation)
    end
    position_value
  end
end
