class CenterCount
  SQUARES = {
    'c6' => true,
    'd6' => true,
    'e6' => true,
    'f6' => true,
    'c5' => true,
    'd5' => true,
    'e5' => true,
    'f5' => true,
    'c4' => true,
    'd4' => true,
    'e4' => true,
    'f4' => true,
    'c3' => true,
    'd3' => true,
    'e3' => true,
    'f3' => true,
  }

  def self.create_abstraction(pieces)
    signature = ''
    pieces.each do |piece|
      center_moves = piece.move_potential.reduce(0) do |sum, move|
        if SQUARES[move]
          sum + 1
        else
          sum
        end
      end

      signature += piece.piece_type + center_moves.to_s if center_moves > 0
    end

    AbstractionHelper.retrieve_abstraction('center_count', signature.downcase)
  end
end
