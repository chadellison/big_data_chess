class Abstraction
  class << self
    def find_abstractions(position)
      board = ChessValidator::BoardLogic.build_board(position)
      pieces = board.values
      turn = position.split[1]
      # control space around each opps king
      # activity ratio for active player
      # center control
      # attack ratio of active
      # returns array inputs
      [
        MaterialAbstraction.find_abstraction(pieces, turn)
      ]
    end
  end
end
