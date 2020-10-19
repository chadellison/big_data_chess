class Pin < ApplicationRecord
  def create_abstraction(pieces)
    pinners = ['r', 'b', 'q']
    pieces.map do |piece|
      if pinners.include?(piece.piece_type.downcase)
        moves = ChessValidator::MoveLogic.moves_for_piece(piece)
        pinned = find_pinned(pieces, moves)
        pinned.present? ? piece.piece_type + pinned.join : ''
      else
        ''
      end
    end.join
  end

  def find_pinned(pieces, moves)
    pieces.map do |piece|
      if moves.include?(piece.position)
        piece.piece_type
      else
        ''
      end
    end
  end
end
