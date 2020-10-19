class Activity < ApplicationRecord
  def create_abstraction(pieces)
    pieces.map do |piece|
      piece.piece_type + piece.valid_moves.size.to_s
    end
  end
end
