class MaterialAbstraction
  def self.find_abstraction(pieces, turn)
    active = 0
    next_turn = 0

    pieces.each do |piece|
      piece_value = PieceAnalyzer.find_piece_value(piece.piece_type)
      if piece.color == turn
        active += piece_value
      else
        next_turn += piece_value
      end
    end

    (active.to_f / next_turn.to_f).round(3)
  end
end
