class Game < ApplicationRecord
  # def play_self(fen_notation)
  #   # move = make_random_move(fen_notation)
  #   move = ChessValidator::MoveLogic.make_random_move(fen_notation)
  #   if move.present?
  #     # convert to new fen
  #     play_self(fen_notation)
  #   else
  #     # return 1 if white wins
  #     # return -1 if black wins
  #     # 0
  #     #
  #     # result
  #   end
  # end

  def calculate_position_value(iterations, fen_notation)
    position_value = 0
    iterations.times do
      position_value += play_self(fen_notation)
    end
    position_value
  end
end
