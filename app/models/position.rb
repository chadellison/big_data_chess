class Position
  def self.create_position(position)
    fen = position.to_fen
    signature = "#{fen.board_string} #{fen.active} #{fen.castling} #{fen.en_passant}"

    AbstractionHelper.retrieve_abstraction('position', signature)
  end
end
